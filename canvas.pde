ArrayList tasks = new ArrayList<Task>();
int scroll = 0;

ArrayList<String> urgents = new ArrayList<String>();
String current_urgents[];
int last_urgent = 0;
float urgent_count = 0;

/* @pjs font="OpenSans-Regular.ttf"*/
color bg_color = color(255);
color scroll_color = color(125);
color urgent_color = color(232,16,0);
int scroll_speed = .5;
float urgent_timer = 225; 
int scroll_urgents_pad = 400;

PFont regular, light;

void setup()
{
  size(screenWidth,screenHeight);
  regular = createFont("OpenSans", 23);
}













void draw() {

	background(bg_color);
	pad = screenWidth*.08;


  // scroll tasks down side	
  int y = tasks.size() * -30;
  for (int i = 0; i < tasks.size(); i++) {
    t = tasks.get(i);
    t.draw(pad,scroll+y)
    y+=30;
  }   
  scroll+=scroll_speed;




	handle_urgent_tasks();



  // check if topmost task is at bottom of the screen
  if (tasks.size() * -30 + scroll > height) {
  	//if it is, reset scroll to top
    scroll = 0;
    // shuffle the tasks
    tasks = shuffle(tasks);
  }

}











public class Task {
	String name;	

	Task(String _name) {
		name = _name;
	}

	void draw(int x, int y) {
		fill(scroll_color);
		textSize(10);
		textAlign(LEFT);
		String shown = truncate(name);
		text(shown,x,y);
	}

	String truncate (String s) {
		int max_chars = 46;  // the maximum chars to be displayed in scrolling view
		if (s.length > max_chars) {
			return s.substring(0,max_chars) + "...";
		}
		return s;
	}
}














void handle_urgent_tasks() {
	
	//check timer
	urgent_count++;
	if (urgent_count>urgent_timer) {
		urgent_count=0;
		pick_current_urgents();
	}

	try {

		draw_urgent_tasks();

	} catch (Exception e) {}

}

void draw_urgent_tasks() {

	int ll = current_urgents.length;

	int u_y = + (screenHeight*.36) - ll*25;
	int urgents_width = screenWidth - (2*pad) - scroll_urgents_pad;
	int u_x = pad+scroll_urgents_pad;

	for (int i = 0; i<ll; i++) {

	    fill(urgent_color);
	    //textAlign(CENTER);
	    textSize(24);
	    text(current_urgents[i], u_x, u_y,urgents_width, 400);//, urgents_width, screenHeigth-u_y);

	    u_y += get_urgent_spacing(u_x+urgents_width, current_urgents[i]);
	  }
}

void get_urgent_spacing(int start_x, String str) {
	float width = textWidth(str);
	if (textWidth>screenWidth-start_x) {
		return 2*48;
	}
	return 48;
}

void setup_urgents() {
	for (int i = 0; i < tasks.size(); i++) {
		urgents.add((String)tasks.get(i).name);
	}

	pick_current_urgents();
}

void pick_current_urgents() {
	int l = (int)random(1,4);

	current_urgents = new String[l];

	// if we're about to overflow,
	// save the rest of the list to current_urgents
	// and reset
	if (last_urgent + l >= urgents.size()) {
    l = urgents.size() - last_urgent;
    current_urgents = new String[l];

    for (int i = 0; i < l; i++) {
      current_urgents[i] = urgents.get(last_urgent+i);
    }
    
    last_urgent = 0;
    
  } else {
    for (int i = 0; i < l; i++) {
      current_urgents[i] = urgents.get(last_urgent+i);
    }
  }

  
  last_urgent += l;
}

//shuffles list in-place
ArrayList shuffle(ArrayList list) {
	int i = list.size();
	int t, r;

	while (0 != i) {
		r = (int)random(0,i);
		i -= 1;

		t = list.get(i);
		list.set(i, list.get(r));
		list.set(r, t);
	}

  return list;
}











void addTask(String task_name) {
	tasks.add(new Task(task_name));
}

void clearTasks() {
	tasks = new ArrayList<Task>();
}


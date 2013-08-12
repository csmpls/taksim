ArrayList tasks = new ArrayList<Task>();
int scroll = 0;

ArrayList<String> urgents = new ArrayList<String>();
String current_urgents[];
int last_urgent = 0;

/* @pjs font="regular.ttf", "light.ttf"; */
color bg_color = color(255);
color scroll_color = color(112);
color urgent_color = color(0);
int scroll_speed = .5;

PFont regular, light;

void setup()
{
  size(screenWidth,screenHeight);
  regular = createFont("regular", 23);
  light = createFont("light", 23);
  textFont(regular);

}

void draw() {

	background(bg_color);
	pad = 40;


  // scroll tasks down side	
  int y = tasks.size() * -30;
  for (int i = 0; i < tasks.size(); i++) {
    t = tasks.get(i);
    t.draw(pad,scroll+y)
    y+=30;
  }   
  scroll+=scroll_speed;


  // display urgent tasks 
	try{

	int u_y = (screenHeight*.3);
	int u_x = (screenWidth*.35);
	for (int i = 0; i<current_urgents.length; i++) {
	    fill(urgent_color);
	    textSize(32);
	    text(current_urgents[i], u_x, u_y);
	    u_y +=48;
	  }
	}

	catch(Exception e) { }


  // check if topmost task is at bottom of the screen
  if (tasks.size() * -30 + scroll > height) {
  	//if it is, reset scroll to top
    scroll = 0;
    //and pick the next tasks to display as urgent
    pick_current_urgents();
    // shuffle the tasks
    tasks = shuffle(tasks);
  }

}


void addTask(String task_name) {
	tasks.add(new Task(task_name));
}

void clearTasks() {
	tasks = new ArrayList<Task>();
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

public class Task {
	String name;

	Task(String _name) {
		name = _name;
	}

	void draw(int x, int y) {
		fill(scroll_color);
		textSize(12);
		String shown = truncate(name);
		text(shown,x,y);
	}

	String truncate (String s) {
		int max_chars = 48;  // the maximum chars to be displayed in scrolling view
		if (s.length > max_chars) {
			return s.substring(0,max_chars) + "...";
		}
		return s;
	}
}
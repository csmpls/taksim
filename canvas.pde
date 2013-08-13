ArrayList tasks = new ArrayList<Task>();
int scroll = 0;

ArrayList<String> urgents = new ArrayList<String>();
String current_urgents[];
int last_urgent = 0;
float urgent_count = 0;

/* @pjs font="OpenSans-Regular.ttf"*/
color bg_color = color(255);
color scroll_color = color(125);
color urgent_color = color(0);
int scroll_speed = .5;
float urgent_timer = 275; 
int scroll_urgents_pad = 400;
float flip = 1;

PFont regular, light;

void setup()
{
  size(screenWidth,screenHeight);
  regular = createFont("OpenSans", 23);
  frameRate(52);
}













void draw() {

	background(bg_color);
	pad = screenWidth*.32;


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

}














void handle_urgent_tasks() {
	
	if (current_urgents) {
		
		//check timer
		urgent_count++;
		if (urgent_count>urgent_timer) {
			urgent_count=0;
			pick_current_urgents();
			flip++;
		}


		if (current_urgents.length>0)
			draw_urgent_tasks();

	}
}

void draw_urgent_tasks() {

	float xmid = halfScreenWidth();
	float ythird = thirdScreenHeight();


	// switches in between two configurations for the x points
	if (flip %2) {
		float x1 = xmid - midpoint(xmid);
		float x2 = xmid + midpoint(xmid);
	} else {
		float x1 = xmid + midpoint(xmid);
		float x2 = xmid - midpoint(xmid);
	} 

	// get the y points for each
	float y1 = midpoint(ythird*1.25);
	float y2 = midpoint(ythird*2.7);
	float y3 = midpoint(ythird*4.25);

	
	// we have to try/catch them in case there are fewer than 3 
	// items to display

	//first big task
   	draw_big_text(current_urgents[0], x1, y1, 10, 60);


   	//second big task
	try { 
    	draw_big_text(current_urgents[1], x2, y2, 40, 40);
  	} catch(Exception e) {} 


  	//third big task
	try { 
    	draw_big_text(current_urgents[2], x1, y3, 60, 20);
  	} catch(Exception e) {} 

	  
}

// Text is centered - so (x, y) here is the midpoint of the text we will draw
// _delay is the time until the text is displayed
// _exit is the time before maximum at which it disappears
void draw_big_text(String string, int x, int y, int _delay, int _exit) {
	
	string = truncate(string);



	float opacity = 255;
	float x_distort = 0;

	// _delay is the time until the text is displayed
	if (urgent_count < _delay) {
		opacity = map(urgent_count, 0, _delay, 0, 250);
	}
	// _exit is the time before maximum at which it disappears
	else if (_exit > abs(urgent_timer-urgent_count)) {
		opacity = map(urgent_count, urgent_timer-_exit, urgent_timer, 255, 10);
		x_distort = map(urgent_count, urgent_timer-_exit, urgent_timer, 0, 4);
	}

	fill(urgent_color, opacity);
	textAlign(CENTER);
	textSize(pick_big_font_size(string, _delay));
	text(string, x+x_distort, y);
	
}

void pick_big_font_size(String s, int _delay) {
		
	if (s.length > 30)
		return 18;
	return 26;
}















void setup_urgents() {
	for (int i = 0; i < tasks.size(); i++) {
		urgents.add((String)tasks.get(i).name);
	}

	pick_current_urgents();
}

void pick_current_urgents() {
	int l = 3; 

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

	String truncate (String s) {
		int max_chars = 46;  // the maximum chars to be displayed in scrolling view
		if (s.length > max_chars) {
			return s.substring(0,max_chars) + "...";
		}
		return s;
	}





float midpoint(float x) {
	return x/2;
}

float halfScreenWidth() {
	return screenWidth/2;
}

float thirdScreenHeight() {
	return screenHeight/3;
}














void addTask(String task_name) {
	tasks.add(new Task(task_name));
}

void clearTasks() {
	tasks = new ArrayList<Task>();
}


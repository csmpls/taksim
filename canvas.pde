ArrayList tasks = new ArrayList<Task>();
int scroll = 0;

ArrayList<String> urgents = new ArrayList<String>();
String current_urgents[];
int last_urgent = 0;
float urgent_count = 0;

/* @pjs font="css/miso.ttf, OpenSans-Regular.ttf"; */

color bg_color = color(255);
color scroll_color = color(125);
int scroll_speed = .5;
float urgent_timer = 275; 
int scroll_urgents_pad = 400;
float flip = 1;
int urgent_text_opacity = 128;


color[] urgents_palette = {
	color(23,255,131),
	color(42,211,232),
	color(97,147,255),
	color(172,99,232),
	color(255,55,146),
	color(255,109,65),
	color(232,172,72),
	color(69,255,44)
};

// for below - see pick_urgents_colors()
color urg_col[]; //array of colors currently used for urgent tasks
int cur_col = 0; //current color of urgents[] swab



PFont regular, miso;



bool dark_mode = 0;




void setup()
{
  size(screenWidth,screenHeight);
  regular = createFont("OpenSans", 23);
  miso = createFont("Miso", 60);
  urg_col = pick_urgents_colors();
  frameRate(52);
}













void draw() {

	background(bg_color);
	pad = screenWidth*.42;


  // scroll tasks down side	
  int y = tasks.size() * -30;
  for (int i = 0; i < tasks.size(); i++) {
    t = tasks.get(i);
    t.draw(pad,scroll+y);
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
		textFont(regular);
		textSize(10);
		textAlign(RIGHT);
		String shown = truncate(name, 42);
		text(shown,x,y);
	}

}






void toggleColors() {

	dark_mode = !dark_mode;

	if (dark_mode) {
		bg_color = color(24);
		scroll_color = color(100);
		urgent_text_opacity = 160;
	}

	else {	
		bg_color = color(255);
		scroll_color = color(125);
		urgent_text_opacity = 128;
	}	
}







void handle_urgent_tasks() {
	
	if (current_urgents) {
		
		//check timer
		urgent_count++;
		if (urgent_count>urgent_timer) {
			urgent_count=0;
			pick_current_urgents();
			urg_col = pick_urgents_colors();
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
	int axis_offset = min(xmid*.3, 100);
	if (flip %2) {
		float x1 = xmid - axis_offset;
		float x2 = xmid + axis_offset;
	} else {
		float x1 = xmid + axis_offset;
		float x2 = xmid - axis_offset;
	} 

	// get the y points for each
	float y1 = midpoint(ythird*1.25);
	float y2 = midpoint(ythird*2.7);
	float y3 = midpoint(ythird*4.25);

	
	// we have to try/catch them in case there are fewer than 3 
	// items to display


	textFont(miso);

	//first big task
	fill(urg_col[0], urgent_text_opacity);
   	draw_big_text(current_urgents[0], x1, y1, 10, 60, urg_col[0]);


   	//second big task
	try { 
		fill(urg_col[1], urgent_text_opacity);
    	draw_big_text(current_urgents[1], x2, y2, 40, 50, urg_col[1]);
  	} catch(Exception e) {} 


  	//third big task
	try { 
		
    	draw_big_text(current_urgents[2], x1, y3, 60, 40, urg_col[2]);
  	} catch(Exception e) {} 

	  
}

// Text is centered - so (x, y) here is the midpoint of the text we will draw
// _delay is the time until the text is displayed
// _exit is the time before maximum at which it disappears
void draw_big_text(String string, int x, int y, int _delay, int _exit, color color) {
	
	string = truncate(string,32);

	float x_distort = 0;

	float fadeout_time = 30;

	float opacity = urgent_text_opacity;

	// _delay is the time until the text is displayed
	if (urgent_count < _delay) {
		opacity = map(urgent_count, 0, _delay, 0, urgent_text_opacity);
	}
	// _exit is the time before maximum at which it disappears
	else if (_exit > abs(urgent_timer-urgent_count)) {
		opacity = map(urgent_count, urgent_timer-_exit, urgent_timer-_exit+fadeout_time, urgent_text_opacity, 10);
		x_distort = map(urgent_count, urgent_timer-_exit, urgent_timer-_exit+fadeout_time, 0, 4);
	}

	textAlign(CENTER);
	fill(color, opacity);
	textSize(47);
	text(string, correct_x(string,x+x_distort), y);
	
}




color[] pick_urgents_colors() {

	urg_col = new color[3];

	for (int i = 0; i < 3; i++) {

		if (cur_col == urgents_palette.length)
			cur_col=0;

		urg_col[i] = urgents_palette[cur_col];
	
		cur_col++;
	}

	return urg_col;
}











float correct_x(String s, float x) {
  int padding = 100; 
  
  float ww = textWidth(s);

  if (x - ww/2 < 0)
    return  ww/2 + padding;
  
  if (x + ww/2 > screenWidth)
    return screenWidth - ww/2 - padding;
  
  return x;
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

	String truncate (String s, int max_chars) {
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


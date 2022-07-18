/* 
 * Author: Marc BOURGEOIS
 * Project : Real Sizer
 * Details: real_sizer.pdf
 * 
 * Copyright [2022] [Marc BOURGEOIS]

 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

color background_color = color(0, 20, 33);

String menu = "calibrate"; // calibrate or display
float op_transition = 0;
boolean transition = false;
int transition_state = 0;

float[] input = {450, 370, 100, 50};
float[] input_x = {425+10, 40, 50, 30};
float[] input_y = {525+10, 40, 50, 30};
float[] btn_draw = {915, 40, 60, 30};
float[] btn_recalibrate = {20, 40, 95, 30};
float[] btn_form = {805, 40, 100, 30};
float[] btn_triangle = {735, 40, 60, 30};
float[] draw_rect = {0, 0, 0, 0};

String input_text = "";
boolean input_active = false;
String input_x_text = "";
boolean input_x_active = false;
String input_y_text = "";
boolean input_y_active = false;

boolean draw_active = false;
String form = "RECTANGLE";
String triangle_type = "T.ISO";
boolean angle_lock = false;
float draw_angle = 0;
PVector center = new PVector(500, 300);
float easing = 0.10;


void setup() {
  size(1000, 600);
  background(background_color);
}

void draw() {
  background(background_color); // clear
  
  // CALIBRATE
  if(menu == "calibrate") {
    fill(0, 102, 153);
    textSize(40);
    fill(255, 255, 255);
    textAlign(CENTER, CENTER);
    text("Calibrate", width/2, (height/2)-50);
    
    textSize(20);
    fill(255, 255, 255);
    textAlign(CENTER, CENTER);
    text("0", width/4, (height/2)+5);
    text("?", (width*3)/4, (height/2)+5);
    
    // calibration line
    strokeWeight(2); 
    stroke(255);
    fill(255);
    line((width/4)+1, (height/2)+30, ((width*3)/4)-1, (height/2)+30); // 500px wide
    line(250, 325, 250, 335);
    line(750, 325, 750, 335);
    
    if(input_active) {
      strokeWeight(3); 
      stroke(83, 163, 223);
    }
    else {
     noStroke(); 
    }
    
    // input
    fill(255);
    rect(input[0], input[1], input[2], input[3], 8, 8, 8, 8);
    textSize(30);
    text("mm", input[0]+(input[2]*1.45), input[1]+(input[3]/2.5));
    textSize(14);
    textAlign(CENTER, CENTER);
    text("(press ENTER)", input[0]+(input[3]/2)+25, input[1]+63);
    
    // input_text
    fill(0);
    textSize(30);
    text(input_text, input[0]+(input[2]/2), input[1]+(input[3]/2.5));
    
    if(isHover(input)) {
      cursor(POINT);
    }
    else {
      cursor(ARROW); 
    }
  }
  
  // DISPLAY
  else if(menu == "display") {
    
    noStroke(); 
    
    // form
    if(draw_active) {
      pushMatrix();
      rectMode(CENTER);
      translate(500, 300);
      
      fill(225);
      PVector p = new PVector(mouseX, mouseY);
      float da = angleBetweenPV_PV(center, p) - draw_angle;
      if(!angle_lock) {
        draw_angle += da * easing;
      }
      rotate(draw_angle);
      
      if(form == "RECTANGLE") {
        rect(0, 0, draw_rect[2], draw_rect[3], 4);
        text(int(degrees(-draw_angle)) + "°", draw_rect[2]/2, (draw_rect[3]/2)+7);
      }
      else if(form == "ELLIPSE") {
        ellipse(0, 0, draw_rect[2], draw_rect[3]);
        textAlign(CENTER, CENTER);
        text(int(degrees(-draw_angle)) + "°", 0, (draw_rect[3]/2)+7);
      }
      else if(form == "TRIANGLE") {
        if(triangle_type == "T.ISO") {
          triangle(-(draw_rect[2]/2), (draw_rect[3]/2), draw_rect[2]/2, (draw_rect[3]/2), 0, -draw_rect[3]/2);
          text(int(degrees(-draw_angle)) + "°", draw_rect[2]/2, (draw_rect[3]/2)+7);
        }
        else if(triangle_type == "T.RECT") {
          triangle(-(draw_rect[2]/2), (draw_rect[3]/2), draw_rect[2]/2, (draw_rect[3]/2), -(draw_rect[2]/2), -draw_rect[3]/2);
          text(int(degrees(-draw_angle)) + "°", draw_rect[2]/2, (draw_rect[3]/2)+7);
        }
        else if (triangle_type == "T.EQUI") {
          
          PVector[] pos = getShapePoints(3, (sqrt(3)*draw_rect[2])/3, 90 * (PI / 180));
          pushMatrix();
          rotate(PI);
          beginShape();
          for(int i = 0; i < pos.length; i++) {
            PVector pt = pos[i];
            vertex(pt.x, pt.y);
          }
          endShape();
          popMatrix();
          text(int(degrees(-draw_angle)) + "°", draw_rect[2]/2, (sqrt(3)*draw_rect[2])/6+7);
        }
      }
      popMatrix();
    }
    rectMode(CORNER);
    fill(background_color);
    rect(395, 30, 210, 65, 4);
    
    fill(255);
    textSize(20);
    textAlign(LEFT, BOTTOM);
    text("500px = " + input_text + "mm", 10, 590);
    textAlign(RIGHT, BOTTOM);
    text("Click to (un)lock rotation", width-10, 590);
    textAlign(LEFT, BOTTOM);
    
    if (form == "TRIANGLE" && triangle_type == "T.EQUI") {
      input_x[0] = 500-20;
    }
    else {
      input_x[0] = 435; 
    }
    
    if(input_x_active) {
      strokeWeight(3); 
      stroke(83, 163, 223);
    }
    else {
     noStroke(); 
    }
    
    // input_x
    fill(255);
    rect(input_x[0], input_x[1], input_x[2], input_x[3], 8, 8, 8, 8);
    textSize(25);
    textAlign(RIGHT, CENTER);
    text("L :", input_x[0]-10, input_x[1]+(input_x[3]/3.2));
    textSize(14);
    textAlign(CENTER, CENTER);
    text("(en mm)", input_x[0]+(input_x[3]/2)+10, input_x[1]+40);
    
    // input_x_text
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(input_x_text, input_x[0]+(input_x[2]/2), input_x[1]+(input_x[3]/2.5));
    
    if(!(form == "TRIANGLE" && triangle_type == "T.EQUI")) {
      if(input_y_active) {
        strokeWeight(3); 
        stroke(83, 163, 223);
      }
      else {
       noStroke(); 
      }
      
      // input_y
      fill(255);
      rect(input_y[0], input_y[1], input_y[2], input_y[3], 8, 8, 8, 8);
      textSize(25);
      textAlign(RIGHT, CENTER);
      text("H :", input_y[0]-10, input_y[1]+(input_y[3]/3.2));
      textSize(14);
      textAlign(CENTER, CENTER);
      text("(en mm)", input_y[0]+(input_y[3]/2)+10, input_y[1]+40);
      
      // input_y_text
      fill(0);
      textSize(20);
      textAlign(CENTER, CENTER);
      text(input_y_text, input_y[0]+(input_y[2]/2), input_y[1]+(input_y[3]/2.5));
    }
    
    if(isHover(btn_draw)) {
      strokeWeight(3); 
      stroke(83, 163, 223);
    }
    else {
      noStroke(); 
    }
    
    
    // btn_draw
    fill(255);
    rect(btn_draw[0], btn_draw[1], btn_draw[2], btn_draw[3], 8, 8, 8, 8);
    
    // btn_draw text
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text("Draw", btn_draw[0]+(btn_draw[2]/2), btn_draw[1]+(btn_draw[3]/2.5));
    
    if(isHover(btn_recalibrate)) {
      strokeWeight(3); 
      stroke(83, 163, 223);
    }
    else {
      noStroke(); 
    }
    
    // btn_recalibrate
    fill(255);
    rect(btn_recalibrate[0], btn_recalibrate[1], btn_recalibrate[2], btn_recalibrate[3], 8, 8, 8, 8);
    
    // btn_recalibrate text
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text("Recalibrate", btn_recalibrate[0]+(btn_recalibrate[2]/2), btn_recalibrate[1]+(btn_recalibrate[3]/2.5));
    
    if(isHover(btn_form)) {
      strokeWeight(3); 
      stroke(83, 163, 223);
    }
    else {
      noStroke(); 
    }
    
    // btn_form
    fill(255);
    rect(btn_form[0], btn_form[1], btn_form[2], btn_form[3], 8, 8, 8, 8);
    
    // btn_form text
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text(form, btn_form[0]+(btn_form[2]/2), btn_form[1]+(btn_form[3]/2.5));
    
    if(form == "TRIANGLE") {
      if(isHover(btn_triangle)) {
        strokeWeight(3); 
        stroke(83, 163, 223);
      }
      else {
        noStroke(); 
      }
      
      // btn_triangle
      fill(255);
      rect(btn_triangle[0], btn_triangle[1], btn_triangle[2], btn_triangle[3], 8, 8, 8, 8);
      
      // btn_triangle text
      fill(0);
      textSize(18);
      textAlign(CENTER, CENTER);
      text(triangle_type, btn_triangle[0]+(btn_triangle[2]/2), btn_triangle[1]+(btn_triangle[3]/2.5));
    }
    
    if(isHover(input_x) || isHover(input_y)) {
      cursor(POINT);
    }
    else {
      cursor(ARROW); 
    }
  }
  noStroke();
  check_panel_transition();
  display_menu();
}

void check_panel_transition() {
  if(transition) {
    if(transition_state == 0) {
      if(op_transition < 255) {
          op_transition += 30;
       }
       else {
        transition_state = 1;
        if(menu == "calibrate")
          menu = "display";
        else
          menu = "calibrate";
       }
    }
    else if(transition_state == 1) {
      if(op_transition > 0) {
          op_transition -= 30;
       }
       else {
        transition_state = 0;
        transition = false;
       }
    }
  }
  fill(0, 0, 0, op_transition);
  rect(0, 0, width, height);
}

void display_menu() {
  noStroke();
  
  fill(255, 255, 255);
  rect(0, 0, width, 20, 0, 0, 12, 12);
  
  fill(0);
  textSize(14);
  textAlign(LEFT, CENTER);
  text(">  Real Sizer", 10, 7);
  textAlign(RIGHT, CENTER);
  text("Marc BOURGEOIS", width-10, 7);
}

void mousePressed(){
  if(menu == "calibrate") {
    if(isHover(input)) {
      input_active = true;
    }
    else {
      input_active = false;
    }
  }
  else {
    if(isHover(input_x)) {
      input_x_active = true;
      input_y_active = false;
    }
    else if(isHover(input_y)) {
      input_x_active = false;
      input_y_active = true;
    }
    else if(isHover(btn_draw)) {
      if(input_x_text != "" && (input_y_text != "" || form == "TRIANGLE" && triangle_type == "T.EQUI")) {
        draw_rect[0] = (width/2)-(((float(input_x_text)*500)/float(input_text))/2);
        draw_rect[1] = (height/2)-(((float(input_y_text)*500)/float(input_text))/2);
        draw_rect[2] = (float(input_x_text)*500)/float(input_text);
        draw_rect[3] = (float(input_y_text)*500)/float(input_text);
        draw_active = true;
        input_x_active = false;
        input_y_active = false;
      }
    }
    else if(isHover(btn_recalibrate)) {
      transition = true;
      input_x_text = "";
      input_y_text = "";
      draw_active = false;
      input_x_active = false;
      input_y_active = false;
    }
    else if (isHover(btn_form)) {
      if(form == "RECTANGLE") form = "ELLIPSE";
      else if(form == "ELLIPSE") form = "TRIANGLE";
      else form = "RECTANGLE";
    }
    else if (isHover(btn_triangle) && form == "TRIANGLE") {
      if(triangle_type == "T.ISO") triangle_type = "T.RECT";
      else if(triangle_type == "T.RECT") triangle_type = "T.EQUI";
      else triangle_type = "T.ISO";
    }
    else {
      input_x_active = false;
      input_y_active = false;
      if(draw_active) {
        if(!angle_lock) angle_lock = true;
        else angle_lock = false;
      }
    }
  }
}

boolean isHover(float[] elem) {
  if(mouseX > elem[0] && mouseY > elem[1] && mouseX < elem[0]+elem[2] && mouseY < elem[1]+elem[3]) {
    return true;
  }
  else {
    return false;
  }
}

void keyTyped() {
  if(menu == "calibrate") {
    if(input_active) {
      if(key == BACKSPACE) {
        input_text = input_text.substring(0, max(0, input_text.length()-1));
      }
      else if(key == ENTER) {
        if(input_text != "") {
          transition = true;
          input_active = false;
        }
      }
      else if(input_text.length() < 4 && ((key >= '0' && key <= '9') || key == '.') ) {
        input_text += key;
      }
    }
    else if(key == TAB) {
     input_active = true; 
    }
  }
  else if(menu == "display") {
    if(!input_x_active && !input_y_active) {
      if(key == TAB) {
        input_x_active = true; 
      }
    }
    else if(input_x_active) {
      if(key == BACKSPACE) {
        input_x_text = input_x_text.substring(0, max(0, input_x_text.length()-1));
      }
      else if(key == ENTER) {
         input_x_active = false;
         if(input_x_text != "" && (input_y_text != "" || form == "TRIANGLE" && triangle_type == "T.EQUI")) {
          draw_rect[0] = (width/2)-(((float(input_x_text)*500)/float(input_text))/2);
          draw_rect[1] = (height/2)-(((float(input_y_text)*500)/float(input_text))/2);
          draw_rect[2] = (float(input_x_text)*500)/float(input_text);
          draw_rect[3] = (float(input_y_text)*500)/float(input_text);
          draw_active = true;
          input_x_active = false;
          input_y_active = false;
        }
      }
      else if(key == TAB) {
        input_x_active = false;
        input_y_active = true;
      }
      else if(input_x_text.length() < 4 && ((key >= '0' && key <= '9') || key == '.') ) {
        input_x_text += key;
      }
    }
    else if(input_y_active) {
      if(key == BACKSPACE) {
        input_y_text = input_y_text.substring(0, max(0, input_y_text.length()-1));
      }
      else if(key == ENTER) {
         input_y_active = false;
         if(input_x_text != "" && input_y_text != "") {
          draw_rect[0] = (width/2)-(((float(input_x_text)*500)/float(input_text))/2);
          draw_rect[1] = (height/2)-(((float(input_y_text)*500)/float(input_text))/2);
          draw_rect[2] = (float(input_x_text)*500)/float(input_text);
          draw_rect[3] = (float(input_y_text)*500)/float(input_text);
          draw_active = true;
          input_x_active = false;
          input_y_active = false;
        }
      }
      else if(key == TAB) {
        input_x_active = true;
        input_y_active = false;
      }
      else if(input_y_text.length() < 4 &&((key >= '0' && key <= '9') || key == '.') ) {
        input_y_text += key;
      }
    }
  }
}

float angleBetweenPV_PV(PVector a, PVector mousePV) {
  // calc angle : the core of the sketch 
  PVector d = new PVector();
  
  // calc angle
  pushMatrix();
  translate(a.x, a.y);
  // delta 
  d.x = mousePV.x - a.x;
  d.y = mousePV.y - a.y;
  // angle 
  float angle1 = atan2(d.y, d.x);
  popMatrix();

  return angle1;
}


PVector[] getShapePoints(int sides, float radius, float rotation) {
  float angleStepSize = TWO_PI / sides;
  PVector[] points = {new PVector (0,0), new PVector (0,0), new PVector (0,0)};
  for(int i = 0; i < sides; i++) {
    points[i] = new PVector(radius * cos(rotation + i * angleStepSize), radius * sin(rotation + i * angleStepSize));
  }
  return points;
}

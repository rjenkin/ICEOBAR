class Destination {
  public float latitude;
  public float longitude;
  public color fill = 0xFFFFFFFF;

  Destination(float latitude, float longitude, color fill) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.fill = fill;
  }
  
  Destination(float latitude, float longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  public void draw() {
    rectMode(RADIUS);

    int[] pos = convertGPSToPixels(this.latitude, this.longitude);
    
    stroke(color(this.fill, 255));
    fill(color(this.fill, 255));
    rect(pos[0], pos[1], 1, 1);

    stroke(color(this.fill, 255));
    fill(color(this.fill, 64));
    rect(pos[0], pos[1], 3, 3);
  }
  
  public void setFill(color fill) {
    this.fill = fill;
  }
}

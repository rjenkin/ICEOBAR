import java.text.SimpleDateFormat;
import java.util.Date;

class Location {
  public Date timestamp;
  public float latitude;
  public float longitude;
  public int accuracy;

  Location(String timestamp, float latitude, float longitude, int accuracy) {
    try {
      this.timestamp = new SimpleDateFormat("y-M-d H:m:s").parse(timestamp);
    }
    catch (Exception e) {
    }

    this.latitude = latitude;
    this.longitude = longitude;
    this.accuracy = accuracy;
  }
}

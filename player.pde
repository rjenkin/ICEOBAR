import java.util.Map;
import java.util.TreeMap;
import java.text.SimpleDateFormat;
import java.util.Date;

class Player {
  public String playerId;
  public String teamId;
  public color colour = 0x80FFFFFF;
  public HashMap<String, Location> locations;

  Player(String playerId, String teamId) {
    this.playerId = playerId;
    this.teamId = teamId;
    this.locations = new HashMap<String, Location>();
  }

  Player(String playerId, String teamId, color colour) {
    this.playerId = playerId;
    this.teamId = teamId;
    this.locations = new HashMap<String, Location>();
    this.colour = colour;
  }
  
  public Location getLocation(String timestamp) {
    // Find exact match...
    if (this.locations.containsKey(timestamp)) {
      return this.locations.get(timestamp);
    }

    try {
      Date d1 = new SimpleDateFormat("y-M-d H:m:s").parse(timestamp);

      Location previous = null;
      Location next = null;
      
      TreeMap<String, Location> sorted = new TreeMap<String, Location>();
      sorted.putAll(this.locations);

      for (Map.Entry<String, Location> entry : sorted.entrySet()) {
        Location location = entry.getValue();
        
        if (location.timestamp.compareTo(d1) == -1) {
          previous = location;
        } else {
          next = location;
          break;
        }
      }
      
      if (previous != null && next != null) {
        // Player hasn't moved, return the previous position..
        if (previous.latitude == next.latitude && previous.longitude == next.longitude) {
          return previous;
        }

        // Player has moved, assumed they moved at a constant rate between the two points..
        long timeOffset = d1.getTime() - previous.timestamp.getTime();
        long timeTotal = next.timestamp.getTime() - previous.timestamp.getTime();
        float amt = (float)timeOffset / (float)timeTotal;
        float latitude = lerp(previous.latitude, next.latitude, amt);
        float longitude = lerp(previous.longitude, next.longitude, amt);

        Location estimatedPosition = new Location(timestamp, latitude, longitude, 0);

        return estimatedPosition;
      }
    }
    catch (Exception e) {
      println("Exception");
      println(e);
    }
        
    return null;
  }

  Location draw(String timekey) {
    // Get location
    Location location = this.getLocation(timekey);
    if (location == null) {
      return null;
    }

    int[] position = convertGPSToPixels(location.latitude, location.longitude);
    stroke(this.colour);
    point(position[0], position[1]);
    
    stroke(color(this.colour, 64));
    fill(color(this.colour, 32));
    ellipse(position[0], position[1], 10, 10);
    
    return location;
  }
  
  void lineFromPreviousPosition(String from, String to) {
    Location fromLocation = this.getLocation(from);
    Location toLocation = this.getLocation(to);
    if (fromLocation == null || toLocation == null) {
      return;
    }
    
    int[] fromPosition = convertGPSToPixels(fromLocation.latitude, fromLocation.longitude);
    int[] toPosition = convertGPSToPixels(toLocation.latitude, toLocation.longitude);
    stroke(color(this.colour, 192));
    line(fromPosition[0], fromPosition[1], toPosition[0], toPosition[1]);
  }

}

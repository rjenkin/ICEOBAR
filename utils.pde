HashMap<String, Player> loadPlayers(String filename, HashMap<String, Integer> teamColours) {
  HashMap<String, Player> players = new HashMap<String, Player>();

  // The data contains each players position over time and is mapped into a Player object
  // that contains a hashmap of their position at a given time.
  Table data = loadTable(filename, "header");
  
  for (TableRow row : data.rows()) {
    String playerId  = row.getString("playerId");
    String teamId    = row.getString("teamId");
    String timestamp = row.getString("timestamp");
    float latitude   = row.getFloat("lat");
    float longitude  = row.getFloat("lng");
    int accuracy     = row.getInt("accuracy");

    // Create player object if they don't exist
    if (!players.containsKey(playerId)) {
      color teamColour = 0x80FFFFFF;
      if (teamColours.containsKey(teamId)) {
        teamColour = teamColours.get(teamId);
      }
      players.put(playerId, new Player(playerId, teamId, teamColour));
    }
    
    // Add the location to the player
    players.get(playerId).locations.put(timestamp, new Location(timestamp, latitude, longitude, accuracy));
  }

  return players;
}

int[] convertGPSToPixels(float latitude, float longitude) {
  int x = (int)map(longitude, 151.196160, 151.217632, 0, 1000 / 2);
  int y = (int)map(latitude, -33.851822, -33.875317, 0, 1300 / 2);
  
  int[] result = new int[2];
  
  result[0] = x;
  result[1] = y;
  
  return result;
}

void drawDestinations(HashMap<String, Destination> destinations){
  for (Map.Entry<String, Destination> d : destinations.entrySet()) {
    Destination destination = d.getValue();
    destination.draw();
    // Debugging...
    //int[] position = convertGPSToPixels(destination.latitude, destination.longitude);
    //text(d.getKey(), position[0] + 10, position[1]);
  }
}

void updateDestinationColour(HashMap<String, Destination> destinations, Location location, color c) {
  if (location == null) {
      return;
  }

  for (Map.Entry<String, Destination> d : destinations.entrySet()) {
    Destination destination = d.getValue();
    float distance = dist(destination.latitude, destination.longitude, location.latitude, location.longitude);
    if (distance < 0.0005) {
      destination.setFill(c);
    }
  }
}

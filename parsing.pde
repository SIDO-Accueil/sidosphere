void parsColor(int j, JSONObject perso)
{
  JSONObject colo = perso.getJSONObject("color");

  int r = colo.getInt("r");
  int g = colo.getInt("g");
  int b = colo.getInt("b");
  Cubes[j].setColor(r, g, b);
  if (Cubes[j].fromTable)
  {
    Cubes[j].clr = r;
    Cubes[j].clg = g;
    Cubes[j].clb = b;
  }  
}
 

void parseVertex(int j, JSONObject perso)
{
  int k = 0;
 
  JSONObject vertex = perso.getJSONObject("nodes");
  while (k < 8)
  {
    JSONObject vectors = vertex.getJSONObject("node" + (k + 1));
    Float x = vectors.getFloat("x") * 10;
    Float y = vectors.getFloat("y") * 10;
    Float z =   vectors.getFloat("z") * 10;
    Cubes[j].addVector(x, y, z, k);
    k++;
  }
}

void parseIn(JSONObject json)
{
  int j = 0;
  JSONArray in = json.getJSONArray("in");

  while (j < in.size() && j < nbCubes)
  {
    JSONObject perso = in.getJSONObject(j);
    String id = perso.getString("id");
    if (!checkId(id, false))
    {
      boolean fromTable = perso.getBoolean("fromTable");
      boolean twitter = perso.getBoolean("hasTwitter");
      Cubes[j].setBase(id, twitter, fromTable);
      if (!fromTable)
        Cubes[j].goIn = true;
      parsColor(j, perso);
      parseVertex(j, perso);
    }
    j++;
  }
}

void parseNb(JSONObject json)
{
  int tmp = 0;
  int i = 0;
  int pos;

  tmp = json.getInt("nb");
  nbIn = tmp - nbFixe;
  nbFixe = tmp;
  if (nbIn > 0)
  {
    while (i != nbIn && i < nbCubesW)
    {
      pos = 0;
      while (WireC[pos].id != 0 && pos < nbCubesW)
        pos++;
      WireC[pos].id = i + 1;
      i++;
    }
  }
/*
  else
  {
    pos = 0;
    while (WireC[pos].id != 0 && pos < nbCubesW)
      pos++;
    while (nbIn >= 0)
    {
      WireC[pos].goOut = true;
      pos--;
      nbIn++;
    }
  }
*/
}

void parseOut(JSONObject json)
{
  int j = 0;
  JSONArray out = json.getJSONArray("out");

  while (j < out.size())
  {
    JSONObject obj = out.getJSONObject(j);    
    String id = obj.getString("id");
    checkId(id, true);
    j++;
  }
}

void load()
{
  JSONObject json;

  GetRequest get = new GetRequest("http://sido.qze.fr:3000/sidomes");
  get.send();
  json = parseJSONObject(get.getContent());
  parseNb(json);
  parseIn(json);
  parseOut(json);  
}

void deleteCube(String id)
{
  int i = 0;

  while (i < nbCubes)
  {
    if (id.equals(Cubes[i].id))
    {
      Cubes[i].setGoOut(true);
      return;
    }
    i++;
  }
}

boolean checkId(String id, boolean out)
{
  int i = 0;

  while (i < nbCubes)
  {
    if (Cubes[i].id != null && id.equals(Cubes[i].id))
    {
      println(Cubes[i].goOut);
      Cubes[i].goOut = out;
      return true;
    }
    i++;
  }
  return false;
}


<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.sql.DataSource"%>
<%@ page import="org.apache.commons.dbutils.QueryRunner"%>
<%@ page import="org.apache.commons.dbutils.handlers.MapListHandler"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="com.fbvalve.util.DbUtil"%>
<%@page import="org.springframework.security.core.context.SecurityContextImpl"%>
<%@page import="com.hotent.platform.model.system.SysUser"%>
<%@ page import="net.sf.json.*"%>
<%!
Object getxxms(String bmlx,String xxsz,String rtnString){
	String sql = "select * from w_crm_modelnum where f_bmlx=? and f_xxsz=?";
	String dataresult = DbUtil.getJson(sql,new Object[]{bmlx,xxsz});
	org.json.JSONArray result = new org.json.JSONArray(dataresult);
	if(result.length()>0){
		return result.getJSONObject(0).get(rtnString);
	}else{
		return null;
	}
}

	JSONObject getxxms(JSONArray map, String field, String rtnString) {
		JSONObject rtn = new JSONObject();
		if (map.size() > 0) {
			Iterator<JSONObject> it = map.iterator();
			while(it.hasNext()){
				JSONObject obj = (JSONObject)it.next();
				System.out.println(obj.toString());
				if (obj.getString("F_BMLX").toString().equals(field)) {
					System.out.println(obj.getString(rtnString));
					rtn.put(rtnString,obj.getString(rtnString));
				}
			}
		} else {
			return null;
		}
		return rtn;
	}

  JSONArray getxxmsMap(String modelNumber){
	  if(modelNumber!=null){
			modelNumber = modelNumber.toUpperCase().trim();
		}
		if("".equals(modelNumber)||modelNumber.length()<14){
			return null;
		}
		//Object[] paras = new Object[]{"A",modelNumber.substring(0,2),"B",modelNumber.substring(2,4),"C",modelNumber.substring(4,5),"D",modelNumber.substring(5,6),"E",modelNumber.substring(2,4)+modelNumber.substring(6,7),
		//		"F",modelNumber.substring(7,9),"G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"H",modelNumber.substring(2,4)+modelNumber.substring(11,12),
		//		"I",modelNumber.substring(12,13),"J",modelNumber.substring(13,14)};
		DataSource ds = DbUtil.getDataSource();
	    QueryRunner queryRunner = new QueryRunner(ds);
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Map<String,String> paras = new HashMap<String,String>();
		paras.put("A",modelNumber.substring(0,2));
		paras.put("B",modelNumber.substring(2,4));
		paras.put("C",modelNumber.substring(4,5));
		paras.put("D",modelNumber.substring(5,6));
		paras.put("E",modelNumber.substring(2,4)+modelNumber.substring(6,7));
		paras.put("F",modelNumber.substring(7,9));
		paras.put("G",modelNumber.substring(2,4)+modelNumber.substring(9,11));
		paras.put("H",modelNumber.substring(2,4)+modelNumber.substring(11,12));
		paras.put("I",modelNumber.substring(12,13));
		paras.put("J",modelNumber.substring(13,14));
		Iterator<Entry<String, String>> iter = paras.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			try{
				String sql = "select * from w_crm_modelnumber where f_bmlx=? and f_xxsz=?";
				//System.out.println((String)entry.getKey()+(String)entry.getValue()+((List)queryRunner.query(sql, new MapListHandler(), new Object[]{(String)entry.getKey(),(String)entry.getValue()})).size());
				list.addAll((List)queryRunner.query(sql, new MapListHandler(), new Object[]{(String)entry.getKey(),(String)entry.getValue()}));
			}catch(Exception ex){
				System.out.println("catach:"+(String)entry.getKey()+(String)entry.getValue());
				return null;
			}finally{

			}
		}
		if(list.size()==10){
			JSONArray json = new JSONArray();
			for (Iterator<Map<String, Object>> li = list.iterator(); li.hasNext();)
			{
			  Map<String, Object> m = (Map)li.next();
			  JSONObject jo = new JSONObject();
			  for (Iterator<Map.Entry<String, Object>> mi = m.entrySet().iterator(); mi.hasNext();)
			  {
				Map.Entry<String, Object> e = (Map.Entry)mi.next();
				jo.put(e.getKey(), e.getValue());
			  }
			  json.add(jo);
			}
			return json;
		}else{
			return null;
		}
	}
%>
<%
	String action = request.getParameter("f");
	if("getdescen".equals(action)){
		//按编码字段和值获取描述信息
		String modelNumber = request.getParameter("modelnumber");
		if(modelNumber!=null){
			modelNumber = modelNumber.trim();
		}else{
			return;
		}
		if("".equals(modelNumber)||modelNumber.length()<14){
			return;
		}
		String valveType = modelNumber.substring(2,4);
		String seatCode = modelNumber.substring(11,12);
		String construction = valveType+modelNumber.substring(6,7);
		String descstr = "";
		if(valveType.equals("BA")){
			if(construction.equals("BA0")||construction.equals("BA1")||construction.equals("BA2")||construction.equals("BA5")){
				descstr = "[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND CLOSURE MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr><tr><td>- BALL:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr>";
				if(seatCode.equals("M")){
					descstr+="<tr><td>- SEAT RETAINER:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"</td></tr><tr><td>-STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr>";
				}else{
					descstr+="<tr><td>- STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr><tr><td>SEAT INSERT:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr>";
				}
				descstr+="<tr><td>O-RING (STEM/SEAT):</td><td>"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Deviation</span>:</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
				descstr+=",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，球体："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，";
				if (seatCode.equals("M"))
				{
					descstr+="阀座："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，";
				}
				else
				{
					descstr+="阀座："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，";
				}
				descstr+="阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"，O形圈："+getxxms("I",modelNumber.substring(12,13),"F_XXZW")+"；<br>其他信息：@{qtxx}@\"";
				descstr+=",\"Model Number : "+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",Ball:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",";
				if(seatCode.equals("M")){
					descstr+="Seat retainer:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",";
				}else{
					descstr+="Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",Seat insert:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",";
				}
				descstr+="O-ring (stem/seat):"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
				descstr+=",\"球体："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，";
				if (seatCode.equals("M"))
				{
					descstr+="阀座："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，";
				}
				else
				{
					descstr+="阀座："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，";
				}
				descstr+="阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
				descstr += ",\"Ball:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",";
				if(seatCode.equals("M")){
					descstr+="Seat retainer:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"\"";
				}else{
					descstr+="Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"\"";
				}
				descstr+="]";
			}else if(construction.equals("BA3")||construction.equals("BA4")||construction.equals("BA6")||construction.equals("BA7")){
				descstr = "[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND CLOSURE MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr><tr><td>- BALL:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"";
				if (seatCode.equals("M")){
					descstr += "</td></tr><tr><td>- SEAT RETAINER:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"</td></tr><tr><td>- STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr>";
				}else{
					descstr += "</td></tr><tr><td>- SEAT RETAINER:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"</td></tr><tr><td>- STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr><tr><td>SEAT INSERT:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr>";
				}
				descstr += "<tr><td>O-RING (STEM/SEAT):</td><td>"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Deviation</span>:</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
				descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，球体："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，";
				if (seatCode.equals("M"))
				{
					descstr += "阀座："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"，阀座密封："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，";
				}else{
					descstr += "阀座支撑圈："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"，阀座嵌入："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，";
				}
				descstr += "O形圈："+getxxms("I",modelNumber.substring(12,13),"F_XXZW")+"；<br>其他信息：@{qtxx}@\"";
				descstr += ",\"Model Number : "+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",Ball:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",";
				if (seatCode.equals("M")){
					descstr += "Seat retainer:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",";
				}else{
					descstr += "Seat retainer:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",Seat insert:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",";
				}
				descstr +="O-ring (stem/seat):"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
				descstr +=",\"球体："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，";
				if (seatCode.equals("M"))
				{
					descstr += "阀座："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
				}else{
					descstr += "阀座支撑圈："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
				}
				descstr += ",\"Ball:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seat retainer:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"\"";
				descstr += "]";
			}
		}else if(valveType.equals("BU")){
			descstr="[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr>";
			if(construction.equals("BU1")){
				descstr += "<tr><td>- DISC:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>- SEAL LINING:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>- STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr>";
			}else if(construction.equals("BU2")||construction.equals("BU3")){
				descstr += "<tr><td>- SEAL SURFACE OF DISC:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>- SEAL SURFACE OF SEAL:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>- STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr>";
			}
			descstr += "<tr><td>O-RING (STEM/SEAT):</td><td>"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td>Deviation</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
			descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，";
			if (construction.equals("BU3"))
			{
				descstr += "蝶板密封面："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，阀座密封面 ："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"，";
			}
			else
			{
				descstr += "蝶板密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面 ："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"，";
			}
			descstr += "O形圈："+getxxms("I",modelNumber.substring(12,13),"F_XXZW")+"；<br>其他信息：@{qtxx}@\"";
			descstr += ",\"<span style=\\\"font-weight:bold;\\\">Model Number</span>:"+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",";
			if(construction.equals("BU1")){
				descstr += "Disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal lining:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",STEM:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",";
			}else if(construction.equals("BU2")||construction.equals("BU3")){
				descstr += "Seal surface of disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seal:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",STEM:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",";
			}
			descstr += "O-ring (stem/seat):"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
			if (construction.equals("BU3"))
			{
				descstr += ",\"阀座密封面 ："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
			}
			else
			{
				descstr += ",\"蝶板密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
			}
			if(construction.equals("BU1")){
				descstr += ",\"Disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"\"";
			}else if(construction.equals("BU2")||construction.equals("BU3")){
				descstr += ",\"Seal surface of disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"\"";
			}
			descstr += "]";
		}else if(valveType.equals("CH")){
			descstr="[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND/OR BONNET/COVER MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr><tr><td>-SEAL SURFACE OF DISC:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>-SEAL SURFACE OF SEAT:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"</td></tr><tr><td>-SEAT:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td>Deviation</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
			descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，阀瓣密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"；阀座："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"<br>其他信息：@{qtxx}@\"";
			descstr += ",\"<span style=\\\"font-weight:bold;\\\">Model Number</span>:"+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",Seal surface of disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seat:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Seat:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
			descstr += ",\"阀瓣密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"\"";
			descstr += ",\"Seal surface of disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seat:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"\"";
			descstr += "]";
		}else if(valveType.equals("GA")){
			descstr="[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND/OR BONNET/COVER MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr><tr><td>-SEAL SURFACE OF WEDGE:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>-SEAL SURFACE OF SEAT:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"</td></tr><tr><td>-STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr><tr><td>SEAT RING:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Deviation</span>:</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
			descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，闸板密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"； 阀座密封："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"<br>其他信息：@{qtxx}@\"";
			descstr += ",\"<span style=\\\"font-weight:bold;\\\">Model Number</span>:"+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",Seal surface of wedge:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seat:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",Seat ring:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
			descstr += ",\"闸板密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
			descstr += ",\"Seal surface of wedge:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+",Seal surface of seat:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+",Stem:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
			descstr += "]";
		}else if(valveType.equals("GP")){
			descstr="[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND/OR BONNET/COVER MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr><tr><td>-SEAL SURFACE OF WEDGE:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>-SEAL SURFACE OF SEAT:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"</td></tr><tr><td>-STEM:</td><td>"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr><tr><td>SEAT RING:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Deviation</span>:</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
			descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，闸板密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"； 阀座密封：；"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"<br>其他信息：@{qtxx}@\"";
			descstr += ",\"<span style=\\\"font-weight:bold;\\\">Model Number</span>:"+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",Seal surface of wedge:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seat:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",Seat ring:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
			descstr += ",\"闸板密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
			descstr += ",\"Seal surface of wedge:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+",Seal surface of seat:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+",Stem:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
			descstr += "]";
		}else if(valveType.equals("GL")){
			descstr="[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND/OR BONNET/COVER MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr><tr><td>- SEAL SURFACE OF DISC:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>- SEAL SURFACE OF SEAT:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+"</td></tr><tr><td>- STEM:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr><tr><td>SEAT RING:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Deviation</span>:</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
			descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，阀瓣密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"；<br>其他信息：@{qtxx}@\"";
			descstr += ",\"<span style=\\\"font-weight:bold;\\\">Model Number</span>:"+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",Seal surface of disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seat:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",Seat ring:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
			descstr += ",\"阀瓣密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(1)+"，阀杆："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";
			descstr += ",\"Seal surface of disc:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seat:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(1)+",Stem:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"\"";
			descstr += "]";
		}else if(valveType.equals("PL")){
			descstr="[\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND/OR BONNET/COVER MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>TRIM DESCRIPTION:</td><td></td></tr>";
			if(construction.equals("PL2")){
				descstr += "<tr><td>- PLUG:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>- SEAL LINING:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>- STEM:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr>";
			}else if(construction.equals("PL1")){
				descstr += "<tr><td>- PLUG:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+"</td></tr><tr><td>- SEAL SURFACE OF SEAT:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>-STEM:</td><td>"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"</td></tr>";
			}
			descstr += "<tr><td>O-RING (STEM/SEAT):</td><td>"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Deviation</span>:</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
			descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，";
			if(construction.equals("PL2")){
				descstr += "塞子："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座衬里："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，阀杆："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"，";
			}else if(construction.equals("PL1")){
				descstr += "塞子："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀座密封面："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"，阀杆："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"，";
			}
			descstr += "O形圈："+getxxms("I",modelNumber.substring(12,13),"F_XXZW")+"；<br>其他信息：@{qtxx}@\"";
			descstr += ",\"<span style=\\\"font-weight:bold;\\\">Model Number</span>:"+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",";
			if(construction.equals("PL2")){
				descstr += "Plug:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal lining:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",Stem:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",";
			}else if(construction.equals("PL1")){
				descstr += "PLUG:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Seal surface of seat:"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",Stem:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+",";
			}
			descstr += "O-ring (stem/seat):"+getxxms("I",modelNumber.substring(12,13),"F_XXYW")+",Operation "+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";

			descstr += ",\"塞子："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(0)+"，阀杆："+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXZW").toString()).get(2)+"\"";

			descstr += ",\"Plug:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(0)+",Stem:"+
				new org.json.JSONArray(getxxms("G",modelNumber.substring(2,4)+modelNumber.substring(9,11),"F_XXYW").toString()).get(2)+"\"";
			descstr += "]";
		}else if(valveType.equals("XX")){
			descstr = "[";
			descstr +="\"<table cellpadding=\\\"0\\\" cellspacing=\\\"0\\\" style=\\\"width: 100%; font-size:7pt; vertical-align:top\\\"><tr><td style=\\\"width:50%\\\">MODEL NUMBER:</td><td style=\\\"width:50%\\\">"+
				modelNumber+"</td></tr><tr><td>VALVE TYPE:</td><td>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+"</td></tr><tr><td>NOMINAL SIZE:</td><td>"+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+"</td></tr><tr><td>PRESSURE RATING:</td><td>"+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+"</td></tr><tr><td>END CONNECTION:</td><td>"+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+"</td></tr><tr><td>CONSTRUCTION:</td><td>"+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+"</td></tr><tr><td>BODY AND/OR BONNET/COVER MATERIAL:</td><td>"+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+"</td></tr><tr><td>SEAT SEAL:</td><td>"+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+"</td></tr><tr><td>OPERATION MODE:</td><td>"+getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Additional Info</span>:</td><td>@{addinfos}@</td></tr><tr><td><span style=\\\"font-weight:bold;\\\">Deviation</span>:</td><td><span style=\\\"color:red\\\">@{deviations}@</span></td></tr></table>\"";
			descstr += ",\"阀门类型："+
				getxxms("B",modelNumber.substring(2,4),"F_XXZW")+"，尺寸："+
				getxxms("A",modelNumber.substring(0,2),"F_XXZW")+"，压力："+
				getxxms("C",modelNumber.substring(4,5),"F_XXZW")+"，连接："+
				getxxms("D",modelNumber.substring(5,6),"F_XXZW")+"，结构："+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXZW")+"，操作："+
				getxxms("J",modelNumber.substring(13,14),"F_XXZW")+"；<br>阀体和阀盖："+
				getxxms("F",modelNumber.substring(7,9),"F_XXZW")+"，阀座密封："+getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXZW")+"；<br>其他信息：@{qtxx}@\"";
			descstr+=",\"<span style=\\\"font-weight:bold;\\\">Model Number</span>:"+
				modelNumber+"<br>"+
				getxxms("B",modelNumber.substring(2,4),"F_XXYW")+","+
				getxxms("A",modelNumber.substring(0,2),"F_XXYW")+","+
				getxxms("C",modelNumber.substring(4,5),"F_XXYW")+","+
				getxxms("D",modelNumber.substring(5,6),"F_XXYW")+","+
				getxxms("E",modelNumber.substring(2,4)+modelNumber.substring(6,7),"F_XXYW")+",Body "+
				getxxms("F",modelNumber.substring(7,9),"F_XXYW")+",Seat seal:"+
				getxxms("H",modelNumber.substring(2,4)+modelNumber.substring(11,12),"F_XXYW")+",Operation "+
				getxxms("J",modelNumber.substring(13,14),"F_XXYW")+"<br><span style=\\\"font-weight:bold;\\\">Additional Info</span>:@{addinfos}@<br><span style=\\\"font-weight:bold;\\\">Deviation</span>:<span style=\\\"color:red\\\">@{deviations}@</span>\"";
			descstr += ",\"\"";
			descstr += ",\"\"";
			descstr += "]";
		}
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(descstr);
	}else if("getmodeldesc_bmlx".equals(action)){
		//按编码字段和值获取描述信息
		String bmlx = request.getParameter("bmlx");
		String xxsz = request.getParameter("xxsz");
		String sql = "select * from w_crm_modelnumber where f_bmlx=? and f_xxsz=?";
		String jsonstr = DbUtil.getJson(sql,new Object[]{bmlx,xxsz});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getinquiry_inquiryno".equals(action)){
		//按照询单号模糊查找记录，
		String inquiryno = request.getParameter("inquiryno");
		String sql = "select ii.ID,f_xch,f_cpbm,f_sl,to_char(f_qtxx) as f_qtxx,to_char(f_addinfo) as f_addinfo,to_char(f_deviations) as f_deviations,f_bj from w_iqs_inquery iqs left join w_iqs_inqueryitem ii on iqs.id=ii.refid where f_xdh like ? order by f_xch";
		String jsonstr = DbUtil.getJson(sql,new Object[]{"%"+inquiryno+"%"});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getinquiry_inquirynoids".equals(action)){
		//按照询单号数组精确查找记录，
		String inquiryno = request.getParameter("inquiryno");
		String sql = "select ii.ID,f_xch,f_cpbm,f_sl,to_char(f_qtxx) as f_qtxx,to_char(f_addinfo) as f_addinfo,to_char(f_deviations) as f_deviations, to_char(f_zwms) as f_zwms,f_bj,f_cc,f_fmlx,f_yl,f_lj,f_jg,f_ftcl,f_njcl,f_fzqr,f_oxq,f_cz from w_iqs_inqueryitem ii where ii.refid in (select regexp_substr(?,'[^,]+',1,rownum)net_code from dual connect by rownum <= (length(?) - length(REGEXP_REPLACE(?, ',','')) + 1)) order by f_xch";
		//out.print(sql);
		String jsonstr = DbUtil.getJson(sql,new Object[]{inquiryno,inquiryno,inquiryno});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getiqspi_inquirynoids".equals(action)){
		//按照询单号数组精确查找记录，
		String inquiryno = request.getParameter("inquiryno");
		String sql = "select ii.ID,f_xch,f_cpbm,f_qty as f_sl,to_char(f_qtxx) as f_qtxx,to_char(f_addinfo) as f_addinfo,to_char(f_deviations) as f_deviations, to_char(f_zwms) as f_zwms,f_bj,f_cc,f_fmlx,f_yl,f_lj,f_jg,f_ftcl,f_njcl,f_fzqr,f_oxq,f_cz from w_iqs_inqueryitem ii left join w_crm_proforma_items pi on pi.f_inquiryid=ii.id where ii.refid in (select regexp_substr(?,'[^,]+',1,rownum)net_code from dual connect by rownum <= (length(?) - length(REGEXP_REPLACE(?, ',','')) + 1)) order by f_xch";
		//out.print(sql);
		String jsonstr = DbUtil.getJson(sql,new Object[]{inquiryno,inquiryno,inquiryno});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getquote_inquiryno".equals(action)){
		//查找报价单子表中的记录
		String quoteid = request.getParameter("quoteid");
		String sql = "select quoteitem.ID,f_InquiryID,f_modelnumber,f_itemno,f_qty,f_tagcode,f_unitprice,f_linetotal,f_adjustminus,f_adjustplus,f_viewtype,to_char(f_fulldescription) AS f_fulldescription,to_char(f_descriptionline) as f_descriptionline from w_crm_quote_items quoteitem left join w_crm_quotation quote on quote.id=quoteitem.refid where quote.id=? order by to_number(f_itemno)";
		String jsonstr = DbUtil.getJson(sql,new Object[]{quoteid});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getproformaitems_piid".equals(action)){
		//查找形式发票子表中的记录
		String piid = request.getParameter("piid");
		String sql = "select pitem.id,pitem.f_modelnumber,f_itemno,f_qty,f_unitprice,f_adjustinus,f_adjustplus,f_linetotal,to_char(f_linedescription) as f_linedescription,f_inquiryid,pi.f_proformainvoice from w_crm_proforma_invoice pi left join w_crm_proforma_items pitem on pi.id = pitem.refid where pi.id=? order by to_number(f_itemno)";
		String jsonstr = DbUtil.getJson(sql,new Object[]{piid});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getpriceexch".equals(action)){
		//查找有效汇率
		String currencytype = request.getParameter("currencytype");
		String sql = "select F_HL from w_crm_hlhsb where F_DHHB = ? and F_SFSX='yes'";
		String jsonstr = DbUtil.getJson(sql,new Object[]{currencytype});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getstandards".equals(action)){
		//返回标准列表
		String sql = "select id,f_standardname,f_year from w_crm_standardslist order by f_year";
		String jsonstr = DbUtil.getJson(sql,new Object[]{});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getstandardsinfo".equals(action)){
		//返回标准内容
		String sid = request.getParameter("sid");
		String sql = "select id,f_standardname,f_year from w_crm_standardslist where id=?";
		String jsonstr = DbUtil.getJson(sql,new Object[]{sid});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getreportrequest".equals(action)){
		//返回合同中需要提交的报告列表
		String sql = "select to_char(id) as id,f_BGMC from w_crm_reportrequest";
		String jsonstr = DbUtil.getJson(sql,new Object[]{});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getsupplier".equals(action)){
		//返回询单中符合条件的供应商
		//废弃的方法，以后需要再改
		String valvetype = request.getParameter("vtype");
		String sql = "SELECT w_iqs_inquery.f_gysbh, w_iqs_inquery.f_gysbhid FROM w_iqs_inqueryitem LEFT JOIN w_iqs_inquery ON w_iqs_inquery.id=w_iqs_inqueryitem.refid AND substr(w_iqs_inqueryitem.f_cpbm,3,2) = ? GROUP BY w_iqs_inquery.f_gysbh, w_iqs_inquery.f_gysbhid HAVING count(w_iqs_inquery.f_gysbh)= (SELECT max(count(w_iqs_inquery.f_gysbh)) FROM w_iqs_inqueryitem LEFT JOIN w_iqs_inquery ON w_iqs_inquery.id=w_iqs_inqueryitem.refid AND substr(w_iqs_inqueryitem.f_cpbm,3,2) = ? GROUP BY w_iqs_inquery.f_gysbh)";
		String jsonstr = DbUtil.getJson(sql,new Object[]{valvetype,valvetype});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getsupplierlist".equals(action)){
		//返回合格供应商列表
		String sql = "select f_companyname,userid from w_crm_suppliers left join sys_user on sys_user.account=w_crm_suppliers.f_suppliercode where F_SUPPLIERTYPE = '合格供应商'";
		String jsonstr  = DbUtil.getJson(sql,new Object[]{});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getinquirylist".equals(action)){
		//String userid = "10000000040008";
		SecurityContextImpl securityContextImpl = (SecurityContextImpl) request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
		Long UserId = ((SysUser)securityContextImpl.getAuthentication().getPrincipal()).getUserId();
		String sql = "select iqs.id,iqs.f_xdh from w_iqs_inquery iqs left join bpm_bus_link buslinks on buslinks.bus_pk=iqs.id where buslinks.bus_creator_id=? or iqs.F_XSFZRID=?";
		String jsonstr = DbUtil.getJson(sql,new Object[]{UserId,UserId});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getinquiryalllist".equals(action)){
		String sql = "select iqs.id,iqs.f_xdh from w_iqs_inquery iqs";
		String jsonstr = DbUtil.getJson(sql,new Object[]{});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getcontractalllist".equals(action)){
		String sql = "select pur.id,pur.f_contractno from w_crm_purchase pur";
		String jsonstr = DbUtil.getJson(sql,new Object[]{});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getmodeltest".equals(action)){
		/*
		String modelNumber = request.getParameter("modelnumber");
		if(modelNumber!=null){
			modelNumber = modelNumber.trim();
		}
		if("".equals(modelNumber)||modelNumber.length()<14){
			return;
		}
		Object mnmap = getxxmsMap(modelNumber);
		if(mnmap!=null){
			//out.println(mnmap+getxxms(new org.json.JSONArray(mnmap),"A","F_XXYW"));
		}
		*/
	}else if("getpaymenttermlist".equals(action)){
		String sql = "select id,f_termname from w_crm_paymentterms order by f_orderby";
		String jsonstr = DbUtil.getJson(sql,new Object[]{});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getshippingtermlist".equals(action)){
		String sql = "select id,f_termname from w_crm_shippingterms order by f_orderby";
		String jsonstr = DbUtil.getJson(sql,new Object[]{});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("gettaskbyid".equals(action)){
		String sql = "select  to_char(F_DELAYTIME, 'yyyy/MM/dd HH24:mi:ss') as BUS_CREATETIME,to_char(sysdate, 'yyyy/MM/dd HH24:mi:ss') as nowtime from w_crm_rwc where w_crm_rwc.id=?";
		String taskid = request.getParameter("taskid");
		String jsonstr = DbUtil.getJson(sql,new Object[]{taskid});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}else if("getzyctaskbyid".equals(action)){
		String sql = "select to_char(F_CKYCSJ, 'yyyy/MM/dd HH24:mi:ss') as BUS_CREATETIME,to_char(sysdate, 'yyyy/MM/dd HH24:mi:ss') as nowtime from w_crm_zyc where w_crm_zyc.id=?";
		String taskid = request.getParameter("taskid");
		String jsonstr = DbUtil.getJson(sql,new Object[]{taskid});
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");  
        response.getWriter().write(jsonstr);
	}
%>

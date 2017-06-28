import com.fbvalve.OrderRecord;
 if(proformainvoice==null){
    def orderfromstr = "PI"+orderfrom;
    List docid = scriptImpl.select("select ID, F_PREFIX,to_char(sysdate,'yy') as F_YEARNUM,F_DOCPREFIX,CASE WHEN LENGTH(F_DOCNUM) < 4 THEN TO_CHAR(F_DOCNUM,'FM0999') ELSE F_DOCNUM END as F_DOCNUM from W_CRM_DOCIDCONTROL where F_DOCID=?",[orderfromstr] as Object[]);
    def pino = docid[0]["F_PREFIX"]+docid[0]["F_YEARNUM"]+docid[0]["F_DOCPREFIX"]+docid[0]["F_DOCNUM"];
    proformainvoice = pino;
    List user = scriptImpl.select("select USERID from sys_user where FULLNAME=?",[onbehalf] as Object[]);
    Map map = new HashMap();
    map.put("F_PROFORMAINVOICE",pino);
    map.put("F_ONBEHALFID",user[0]["USERID"]);
    scriptImpl.updateByTableName(businessKey,"W_CRM_PROFORMA_INVOICE",map);
    Map docmap = new HashMap();
    docmap.put("F_YEARNUM",docid[0]["F_YEARNUM"]);
    docmap.put("F_DOCNUM",((docid[0]["F_DOCNUM"]) as Integer)+1);
    scriptImpl.updateByTableName(docid[0]["ID"] as String,"W_CRM_DOCIDCONTROL",docmap);
    OrderRecord.generateContractReview(businessKey,pino);
}
List purchaseitem = scriptImpl.select("select * from ( select id,f_pino from w_crm_ordercn union all select id,f_pino from w_crm_orderus )where f_pino=?",[proformainvoice] as Object[]);
if(purchaseitem.size()==0){
    scriptImpl.generateOrderRecord(businessKey,proformainvoice);
}else{
    OrderRecord.updateRecord(businessKey,proformainvoice);
}
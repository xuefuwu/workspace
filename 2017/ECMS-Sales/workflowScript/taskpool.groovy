//结束并删除记录
Map map = new HashMap();
map.put("F_RDEL","yes");
scriptImpl.updateByTableName(businessKey,"w_CRM_RWC",map);

//任务池接受
Map map = new HashMap();
map.put("F_ZXR",scriptImpl.getCurrentName());
map.put("F_ZXRID",scriptImpl.getCurrentUserId());
def now= new Date();
map.put("F_RWJSSJ",now); 
scriptImpl.updateByTableName(businessKey,"w_CRM_RWC",map);


//提交任务情况
Map map = new HashMap();
def now= new Date();
map.put("F_ZXR",scriptImpl.getCurrentName());
map.put("F_ZXRID",scriptImpl.getCurrentUserId());
map.put("F_WCSJ",now); 
scriptImpl.updateByTableName(businessKey,"w_CRM_RWC",map);

//重复提交任务
Map map = new HashMap();
def now= new Date();
map.put("F_ZXR",scriptImpl.getCurrentName());
map.put("F_ZXRID",scriptImpl.getCurrentUserId());
  if(rwzt=="completed")
map.put("F_WCSJ",now); 
scriptImpl.updateByTableName(businessKey,"w_CRM_RWC",map);

//评价任务情况
Map map = new HashMap();
map.put("F_PJR",scriptImpl.getCurrentName());
map.put("F_PJRID",scriptImpl.getCurrentUserId());
scriptImpl.updateByTableName(businessKey,"w_CRM_RWC",map);

//结算任务
import com.fbvalve.TaskPool;
TaskPool.generateRecord(businessKey);

//提交任务分支
rwzt=="notstarted"||rwzt=="inprogress"

//评价任务完成情况分支
rwzt=="completed"||rwzt=="termination"

--道具：雪白水晶球ID:30504018>
--脚本号 x889016
--Author: 张壮 2008-11-24

x889016_g_scriptId = 889016

x889016_g_CrystalBoxPrize = {
	                10141081,
	                10141102,
	                30505804,
	                30505805,
	                30502000,
	                30502001,
	                30502002,
	                30008002,
	                30008003,
	                30607001,
	                30900006,
	                30008007,
	                30008029,
	                30501152					
}	

x889016_g_strGongGaoInfo = {
	"#{_INFOUSR%s}#c00FFFF看着晶莹的#G#{_ITEM30504018}#c00FFFF，拿起魔布爱怜地轻轻擦拭，一阵白雾缭绕，掉出了一个#{_INFOMSG%s}#c00FFFF。",
	"#{_INFOUSR%s}#c00FFFF看着晶莹的#G#{_ITEM30504018}#c00FFFF，拿起魔布爱怜地轻轻擦拭，一阵白雾缭绕，掉出了一个#{_INFOMSG%s}#c00FFFF。",
	"#{_INFOUSR%s}#c00FFFF看着晶莹的#G#{_ITEM30504018}#c00FFFF，拿起魔布爱怜地轻轻擦拭，一阵白雾缭绕，掉出了一个#{_INFOMSG%s}#c00FFFF。",
}
--**********************************
--事件交互入口
--**********************************
function x889016_OnDefaultEvent( sceneId, selfId, bagIndex )
-- 不需要这个接口，但要保留空函数
end

--**********************************
--这个物品的使用过程是否类似于技能：
--系统会在执行开始时检测这个函数的返回值，如果返回失败则忽略后面的类似技能的执行。
--返回1：技能类似的物品，可以继续类似技能的执行；返回0：忽略后面的操作。
--**********************************
function x889016_IsSkillLikeScript( sceneId, selfId)
	return 1; --这个脚本需要动作支持
end

--**********************************
--直接取消效果：
--系统会直接调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：已经取消对应效果，不再执行后续操作；返回0：没有检测到相关效果，继续执行。
--**********************************
function x889016_CancelImpacts( sceneId, selfId )
	return 0; --不需要这个接口，但要保留空函数,并且始终返回0。
end

--**********************************
--条件检测入口：
--系统会在技能检测的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：条件检测通过，可以继续执行；返回0：条件检测失败，中断后续执行。
--**********************************
function x889016_OnConditionCheck( sceneId, selfId )
	--校验使用的物
	if(1~=LuaFnVerifyUsedItem(sceneId, selfId)) then
		return 0
	end
--因为转蛋本身消耗一个，会多出一个空格，且好运礼盒最多奖励3个所以判断剩余空间<2	
--因为雪白水晶励物品有的在道具栏
	local FreeSpace = LuaFnGetPropertyBagSpace( sceneId, selfId )
	if( FreeSpace < 3 ) then 
	   local strNotice = "背包空间不足。"
		 x889016_ShowNotice( sceneId, selfId, strNotice)
	   return 0
	end			
	return 1; --不需要任何条件，并且始终返回1。
end

--**********************************
--消耗检测及处理入口：
--系统会在技能消耗的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：消耗处理通过，可以继续执行；返回0：消耗检测失败，中断后续执行。
--注意：这不光负责消耗的检测也负责消耗的执行。
--**********************************
function x889016_OnDeplete( sceneId, selfId )
	if(0<LuaFnDepletingUsedItem(sceneId, selfId)) then
		return 1;
	end

	return 0;
end

--**********************************
--只会执行一次入口：
--聚气和瞬发技能会在消耗完成后调用这个接口（聚气结束并且各种条件都满足的时候），而引导
--技能也会在消耗完成后调用这个接口（技能的一开始，消耗成功执行之后）。
--返回1：处理成功；返回0：处理失败。
--注：这里是技能生效一次的入口
--**********************************
function x889016_OnActivateOnce( sceneId, selfId )

    --数据统计：转蛋的使用
	  LuaFnAuditZhuanDanUsed(sceneId, selfId, 16, 0)
		
    local RandomBase = GetZhuanDanItemDropCount( sceneId, selfId, 16)
    if( RandomBase > 0 ) then    
       	
        local RandomNum = random( 0, RandomBase - 1 )
        local RandomID, Notice = ZhuanDanItemDropRandom( sceneId, selfId, RandomNum, 16 )
        local PrizeNum = 0
        if( RandomID == x889016_g_CrystalBoxPrize[5] ) then
          PrizeNum = 10
        elseif (RandomID == x889016_g_CrystalBoxPrize[6] or RandomID == x889016_g_CrystalBoxPrize[9] or RandomID == x889016_g_CrystalBoxPrize[13]) then
        	PrizeNum = 4
        elseif (RandomID == x889016_g_CrystalBoxPrize[7] or RandomID == x889016_g_CrystalBoxPrize[8]) then
          PrizeNum = 3
        elseif (RandomID == x889016_g_CrystalBoxPrize[11]) then
          PrizeNum = 2
        else
          PrizeNum = 1
        end
        
        if( RandomID > 0 ) then
           BeginAddItem(sceneId)
				   AddItem( sceneId, RandomID, PrizeNum )
			     local Ret = LuaFnEndAddItemIgnoreFatigueState( sceneId, selfId )
			     if Ret > 0 then
			       	LuaFnAddItemListToHumanIgnoreFatigueState(sceneId,selfId)
			       	
			       	if 1 == Notice then
			       	   local szItemTransfer = GetItemTransfer(sceneId,selfId,0)
					       x889016_ShowRandomSystemNotice( sceneId, selfId, szItemTransfer )
				      end
				      
				      local ItemName = GetItemName(sceneId, RandomID)
				      local strNotice = "您得到了"..ItemName
				      x889016_ShowNotice( sceneId, selfId, strNotice)
				      LuaFnSendSpecificImpactToUnit(sceneId, selfId, selfId, selfId, 18, 0);
				   else
				      local strNotice = "背包空间不足"
				      x889016_ShowNotice( sceneId, selfId, strNotice)
			     end
			
        end
        
    end
    
	return 1;
end

--**********************************
--引导心跳处理入口：
--引导技能会在每次心跳结束时调用这个接口。
--返回：1继续下次心跳；0：中断引导。
--注：这里是技能生效一次的入口
--**********************************
function x889016_OnActivateEachTick( sceneId, selfId)
	return 1; --不是引导性脚本, 只保留空函数.
end

function x889016_ShowNotice( sceneId, selfId, strNotice)
	BeginEvent( sceneId )
		AddText( sceneId, strNotice )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )    
end

function x889016_ShowRandomSystemNotice( sceneId, selfId, strItemInfo )
	
	local PlayerName = GetName(sceneId,selfId)
	local nMsgIndex = random( 1, 3 )
	local str
	if nMsgIndex == 1 then
		str = format( x889016_g_strGongGaoInfo[1], PlayerName, strItemInfo)
	elseif nMsgIndex == 2 then
		str = format( x889016_g_strGongGaoInfo[2], PlayerName, strItemInfo )
	else
		str = format( x889016_g_strGongGaoInfo[3], PlayerName, strItemInfo)
	end
	BroadMsgByChatPipe( sceneId, selfId, str, 4 )
	
end

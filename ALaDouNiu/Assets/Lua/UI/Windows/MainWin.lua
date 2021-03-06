--
module("UI.Windows.MainWin", package.seeall)

local UIWinMgr = require("UI.UIWinMgr").UIWinMgr
local UIUtility = require("UI.Utility")
local UIWindow = require("UI.UIWindow").UIWindow
local GameObject = UnityEngine.GameObject
local MainUserData = require("DynamicData.MainUserData").MainUserData

local IosPendingTool = require("IosPendingTool").IosPendingTool
local isIosPending = IosPendingTool.IsPending()

MainWin = UIWindow:new()
MainWin.name = "MainWin" --窗体名字

--初始化界面
function MainWin:Init()
    --初始化界面，保存引用控件
    local t = self.Container.transform
    self.NameLabel = UIUtility.FindContorl("UILabel", "NameLabel", t)
    self.IDLabel = UIUtility.FindContorl("UILabel", "IDLabel", t)
    self.ZsLabel = UIUtility.FindContorl("UILabel", "ZsLabel", t)
    self.HeadIcon = UIUtility.FindContorl("UITexture", "TouXiangSp", t)
    self.CrBtn = UIUtility.GetChildTransform("m_CreatRoom", t, true)
    self.m_BackRoom = UIUtility.GetChildTransform("m_BackRoom", t, true)
    self.JrBtn = UIUtility.GetChildTransform("m_JoinRoom", t, true)
    self.ShopBtn = UIUtility.GetChildTransform("FanKa", t, true)
    self.SheZiBtn = UIUtility.GetChildTransform("m_SettingBtn", t, true)
    self.RuleBtn = UIUtility.GetChildTransform("m_Help", t, true)
    self.ActivityBtn = UIUtility.GetChildTransform("m_Activity", t, true)
    self.ZhanJiBtn = UIUtility.GetChildTransform("m_Record", t, true)
    self.FenXiang = UIUtility.GetChildTransform("m_Sharing", t, true)
    self.Circle = UIUtility.GetChildTransform("m_Circle", t, true)
    -- self.InfoLabel = UIUtility.FindContorl("UILabel", "TongZhiBg", t)

    self.RoomInfo = UIUtility.GetChildTransform("m_RoomInfo", t, true) -- 开房信息

    -- local UIScrollView = require("UI.Com.UIScrollView").UIScrollView
    self.m_Recruiting = UIUtility.GetChildTransform("m_Recruiting", t, true) -- 代理招募
    self.m_Announcement = UIUtility.GetChildTransform("m_Announcement", t, true) -- 公告
    self.mAgency = UIUtility.GetChildTransform("m_Agency", t, true) -- 代理
    self.m_Expression = UIUtility.GetChildTransform("m_Expression", t, true) -- 表情
    self.m_Service  = UIUtility.GetChildTransform("m_Service", t, true) -- 客服

    self.copyID = UIUtility.GetChildTransform("copy_ID", t, true)



    -- self.ShopButton = UIUtility.GetChildTransform("m_ShopButton", t, true)
    --self.GirlParent = GameObject.Find("Girl")


    self.UpTime = 0
    self:BindEvents()
end

function MainWin:OnClose()
    UIWinMgr:CloseWindow("MainBgWin")
    self.UpTime = 0
    self.isGirlInited = false
    if self.countTime ~= nil then
        CountDownMgr.Instance:RemoveCountDown(self.countTime, false)
        self.countTime = nil
    end
end

function MainWin:OnShow()
    UIWinMgr:OpenWindow("MainBgWin")
    if isIosPending then
        --ios审核游客登陆类
        self.WeiXingSp.gameObject:SetActive(false)
    else
        --self.WeiXingSp.gameObject:SetActive(true)
    end

    self.NameLabel.text = MainUserData.nickname
    self.IDLabel.text = "ID:" .. MainUserData.uid
    self.ZsLabel.text = MainUserData.diamond
    local icon = self.HeadIcon.mainTexture
    if not icon then
        local WWWTexture = require("NetWork.NetHttp").WWWTexture
        function callBack(isok, www)
            if isok then
                self.HeadIcon.mainTexture = www.texture
            end
        end
        WWWTexture(MainUserData.headimg, callBack)
        Debug.log("开始获取头像：" .. tostring(MainUserData.headimg))
    end

    local GameHost = require("Module.GameModule.GameHost").GameHost
    if GameHost.myIndex == nil then
        self.CrBtn.gameObject:SetActive(true)
        self.m_BackRoom.gameObject:SetActive(false)
    else
        self.CrBtn.gameObject:SetActive(false)
        self.m_BackRoom.gameObject:SetActive(true)
    end
    
    self:getRoomNumber()
 
end
CountDownMgr.Instance:CreateCountDown(0.32, 0.32, LoadGirl)


function MainWin:RemoveTheTime()
    self.UpTime = 0
    self.isGirlInited = true
    if self.countTime ~= nil then
        CountDownMgr.Instance:RemoveCountDown(self.countTime, false)
        self.countTime = nil
    end
end

function MainWin:LoginSet()
    self.TopTweenPos.delay = 0
    self.BottomTweenPos.delay = 0
    self.RightTweenPos.delay = 0
    self.LeftTweenPos.delay = 0
end

function MainWin:ShopSet()
    self.TopTweenPos.delay = 0.5
    self.BottomTweenPos.delay = 0.5
    self.RightTweenPos.delay = 0.5
    self.LeftTweenPos.delay = 0.5
end

function MainWin:BindEvents()
    function ZsNum()
        local MainUserData = require("DynamicData.MainUserData").MainUserData
        self.ZsLabel.text = MainUserData.diamond
    end
    self.MyZsNum = ZsNum
 
   Event.AddListener(EventDefine.OnMainUserDataChange, self.MyZsNum)
    function OpenCreRoomWin()
        UIWinMgr:OpenWindow("CreateRoomWin")
    end
    UIHelper.BindUIEvnet("Click", OpenCreRoomWin, self.CrBtn.gameObject)

    function OpenJRWin()
        UIWinMgr:OpenWindow("JoinRoomWin")
    end
    UIHelper.BindUIEvnet("Click", OpenJRWin, self.JrBtn.gameObject)
    


    function lickopyIDbuttonAction()

        Debug.log("ddddddddd")
        local RoomModule = require("Module.RoomModule").RoomModule
        RoomModule.copyOtherString_Action(MainUserData.uid,"ID")


    end

    -- UIHelper.BindUIEvnet("Click", lickopyIDbuttonAction ,self.copyID.gameObject)
    UIHelper.BindUIEvnet("Click", lickopyIDbuttonAction, self.copyID.gameObject)

    --ISO审核商城按钮点击事件
    function OpenShopWin()
        -- UIWinMgr:OpenWindow("ShopWin")

        UIWinMgr:OpenNotice("请联系上级代理")
        -- Debug.log("还没有")

    end
    UIHelper.BindUIEvnet("Click", OpenShopWin, self.ShopBtn.gameObject)
    -- UIHelper.BindUIEvnet("Click", OpenShopWin, self.ShopButton.gameObject)


    --招募代理按钮点击事件
    function clickmRecruitingButt()
        Debug.log("招募代理")
        UIWinMgr:OpenPromptMaskWin("敬请期待")

    end
    UIHelper.BindUIEvnet("Click", clickmRecruitingButt, self.m_Recruiting.gameObject)

    --公告按钮点击事件
    function clickmAnnouncementButt()
        
        UIWinMgr:OpenPromptMaskWin("敬请期待")
        
    end
    UIHelper.BindUIEvnet("Click", clickmAnnouncementButt, self.m_Announcement.gameObject)

    -- --点击代理按钮点击事件
    function clickmAgencyButt()
        UIWinMgr:OpenPromptMaskWin("敬请期待")
    end

    UIHelper.BindUIEvnet("Click", clickmAgencyButt, self.mAgency.gameObject)

    --表情按钮点击事件
    function clikcmExpression()
        UIWinMgr:OpenPromptMaskWin("敬请期待")
    end
    UIHelper.BindUIEvnet("Click", clikcmExpression, self.m_Expression.gameObject)

    --客服按钮点击事件
    function m_Service()
        UIWinMgr:OpenPromptMaskWin("敬请期待")
    end
    UIHelper.BindUIEvnet("Click", m_Service, self.m_Service.gameObject)

    --开房信息按钮点击事件
    function OpRoomInfoWin()
        Debug.log("开房信息")
        UIWinMgr:OpenWindow("RoomInfoWin")

    end
    UIHelper.BindUIEvnet("Click", OpRoomInfoWin, self.RoomInfo.gameObject)


    --分享按钮点击事件
    function OpenFenXiangWin()
        UIWinMgr:OpenWindow("FenXiangWin")
    end
    UIHelper.BindUIEvnet("Click", OpenFenXiangWin, self.FenXiang.gameObject)

    --牌友圈按钮点击事件
    function OpenCreateClubWin()
        UIWinMgr:OpenWindow("ClubManageWin")
    end
    UIHelper.BindUIEvnet("Click", OpenCreateClubWin, self.Circle.gameObject)

    --战绩按钮点击事件
    function OpenRecordWin()
        UIWinMgr:OpenWindow("GameRecordWin")
    end
    UIHelper.BindUIEvnet("Click", OpenRecordWin, self.ZhanJiBtn.gameObject)

    --帮助按钮点击事件
    function OpenRuleWin()
        UIWinMgr:OpenWindow("HelpWin")
    end
    UIHelper.BindUIEvnet("Click", OpenRuleWin, self.RuleBtn.gameObject)

    --活动按钮点击事件
    function OpenActWin()
        -- UIWinMgr:OpenNotice("此功能暂未开放，敬请期待。")
        --UIWinMgr:OpenWindow("ActivityWin")
        UIWinMgr:OpenPromptMaskWin("敬请期待")
    end
    UIHelper.BindUIEvnet("Click", OpenActWin, self.ActivityBtn.gameObject)


    -- 设置按钮点击事件
    function OpenSettingWin()
        UIWinMgr:OpenWindow("SettingWin")
    end
    UIHelper.BindUIEvnet("Click", OpenSettingWin, self.SheZiBtn.gameObject)


    function LoginOut()
        if UnityEngine.PlayerPrefs.HasKey("lastSession") then
            UnityEngine.PlayerPrefs.DeleteKey("lastSession")
        end
        if UnityEngine.PlayerPrefs.HasKey("lastClubID") then
            UnityEngine.PlayerPrefs.DeleteKey("lastClubID")
        end
        local NetMgr = require("NetWork").NetMgr
        NetMgr:CloseConnection()

        self:Close()
        local GameScene = require("Scene.GameScene").GameScene
        GameScene.isNeedNormalLogin = true
        local MapModule = require("Module.MapModule").MapModule
        MapModule:OpenLoginWin()
        self:RemoveTheTime()
        UnityEngine.GameObject.Destroy(self.G_girl)
    end


    function BackRoom()
        self.m_BackRoom.gameObject:SetActive(false)
        self.CrBtn.gameObject:SetActive(true)

        self:Close()
        UIWinMgr:OpenWindow("GameWin")
    end
    
    UIHelper.BindUIEvnet("Click", BackRoom, self.m_BackRoom.gameObject)


    --界面前后台切换
    function ISPause(pause)

         if pause then
            --切入后台

         else
            --切回前台   
            self:getRoomNumber()
         end
    end

    local BehaviourEvent = require("BehaviourEvent").BehaviourEvent
    BehaviourEvent:Bind("OnApplicationPause", self.Container.gameObject, ISPause)




end

function MainWin:OnDestroy()
    Event.RemoveListener(EventDefine.OnMainUserDataChange, self.MyZsNum)
    Event.RemoveListener(EventDefine.OnAddClub, self.ShowMyClubWarp)
    Event.RemoveListener(EventDefine.OnDelClub, self.ShowMyClubWarp)
    Event.RemoveListener(EventDefine.OnUpClub, self.ShowMyClubWarp)
end



-- 获取房间号
function MainWin:getRoomNumber()
    
        local RoomModule = require("Module.RoomModule").RoomModule           
        RoomModule.getCopyClipBoardString()
    
        -- function getCopyClipBoardCallback(boardString)
    
        --     local copyState = UnityEngine.PlayerPrefs.GetInt("copyState")
    
        --     if boardString == "1" or boardString == nil or boardString == "" or copyState == 1 then
    
        --         UnityEngine.PlayerPrefs.SetInt("copyState", 2)
        --         return
        --     end
    
        --     if string.match(boardString ,"疯狂阿拉房号") == "疯狂阿拉房号" then
        --         local p1 = string.find(boardString,"%[")
        --         local p2 = string.find(boardString,"%]")
        --         local code = string.sub(boardString, p1+1, p2-1)                
        --         Debug.log("code"..#code) 
        --         local RoomModule = require("Module.RoomModule").RoomModule           
        --         RoomModule.JoinRoomBeforeCm(code)
    
        --     else
        --         UIWinMgr:OpenPromptMaskWin("内容不是疯狂阿拉房间号")   
        --     end 
        -- end
        -- self.callback = getCopyClipBoardCallback
        -- PlatformTool.Instance:CopyClipboardString(self.callback)
    
    end
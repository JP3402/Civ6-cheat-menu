-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------

include("Civ6Common");
include("InstanceManager");
include("SupportFunctions");
include("PopupDialog");
include("AnimSidePanelSupport");
include("CitySupport");

local playerID 						= Game.GetLocalPlayer();
local pPlayer 						= Players[playerID];
local pTreasury 					= pPlayer:GetTreasury();
local pReligion 					= pPlayer:GetReligion();
local pEnvoy 						= pPlayer:GetInfluence();
local pVis 							= PlayersVisibility[playerID];
local pNewGP 						= 1;
local pNewEnvoy 					= 5;
local pNewFavor						= 100;
local m_hideCheatPanel				= false;
local m_IsLoading:boolean			= false;
local m_IsAttached:boolean			= false;
local m_ControlOtherCivs			= false;

function GetCurrentTargetPlayerID()
	if m_ControlOtherCivs and ExposedMembers.MOD_CheatMenu and ExposedMembers.MOD_CheatMenu.iPlayer then
		return ExposedMembers.MOD_CheatMenu.iPlayer;
	end
	return Game.GetLocalPlayer();
end

-- // ----------------------------------------------------------------------------------------------
-- // MENU BUTTON FUNCTIONS
-- // ----------------------------------------------------------------------------------------------

function ChangeLUXURYResources(playerID)
	local targetID = GetCurrentTargetPlayerID();
 	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.ChangeLUXURYResources(targetID);
	end
end
function ChangeSTRATEGICResources(playerID)
	local targetID = GetCurrentTargetPlayerID();
 	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.ChangeSTRATEGICResources(targetID);
	end
end
function ChangeEraScore()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
        ExposedMembers.MOD_CheatMenu.ChangeEraScore(targetID);
    end
	RefreshActionPanel();
end
function ChangeEraScoreBack()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
        ExposedMembers.MOD_CheatMenu.ChangeEraScoreBack(targetID);
    end
	RefreshActionPanel();
end
function ChangeGold()
	local pNewGold:number = tonumber(Controls.GoldAmount:GetText());
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeGold(targetID, pNewGold);
    end
end
function ChangeGoldMore()
	local pNewGold = 100000;
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
        ExposedMembers.MOD_CheatMenu.ChangeGold(targetID, pNewGold);
    end
end
function CompleteProduction()
	local pNewProduction:number = tonumber(Controls.ProductionAmount:GetText());
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.CompleteProduction(targetID, pNewProduction);
	end
end
function CompleteAllResearch()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.CompleteAllResearch(targetID);
	end		
end
function CompleteAllCivic()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.CompleteAllCivic(targetID);
	end		
end
function CompleteResearch()
	local targetID = GetCurrentTargetPlayerID();
	local pTargetPlayer = Players[targetID];
	local pTechs = pTargetPlayer:GetTechs()
	local pRTech = pTechs:GetResearchingTech()	
	if pRTech >= 0 then
		local pCost = pTechs:GetResearchCost(pRTech)	
		local pProgress = pTechs:GetResearchProgress(pRTech)
		local pResearchComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			ExposedMembers.MOD_CheatMenu.CompleteResearch(targetID, pResearchComplete);
		end		
	end
end
function CompleteCivic()
	local targetID = GetCurrentTargetPlayerID();
	local pTargetPlayer = Players[targetID];
	local pCivics = pTargetPlayer:GetCulture()
	local pRCivic = pCivics:GetProgressingCivic()
	if pRCivic >= 0 then		
		local pCost = pCivics:GetCultureCost(pRCivic)	
		local pProgress = pCivics:GetCulturalProgress(pRCivic)
		local pCivicComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			ExposedMembers.MOD_CheatMenu.CompleteCivic(targetID, pCivicComplete);
		end
	end	
end
function ChangeFaith()
	local pNewFaith:number = tonumber(Controls.FaithAmount:GetText());
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeFaith(targetID, pNewFaith);
    end
end
function ChangePopulation()
	local pCity = UI.GetHeadSelectedCity();
	if pCity ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangePopulation(pCity:GetOwner(), pCity, pNewPopulation);
	end
end
function RestoreCityHealth()
	local pCity = UI.GetHeadSelectedCity();
	if pCity ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.RestoreCityHealth(pCity:GetOwner());
	end
end
function ChangeCityLoyalty()
	local pCity = UI.GetHeadSelectedCity();
	if pCity ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeCityLoyalty(pCity:GetOwner());
	end
end
function DestroyCity()
	local pCity = UI.GetHeadSelectedCity();
	if pCity ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.DestroyCity(pCity:GetOwner());
	end
end
function UnitPromote()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
		ExposedMembers.MOD_CheatMenu.UnitPromote(ownerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitMovementChange()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
        ExposedMembers.MOD_CheatMenu.UnitMovementChange(ownerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitAddMovement()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
        ExposedMembers.MOD_CheatMenu.UnitAddMovement(ownerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
    end
end
function OnDuplicate()
	local pRelig = nil;
	if pPlayer:GetReligion() ~= nil and pPlayer:GetReligion():GetReligionTypeCreated() ~= -1 then
		pRelig = pPlayer:GetReligion():GetReligionTypeCreated();
	end
	local pUnit = UI.GetHeadSelectedUnit();
	if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
		local unitType:string = GameInfo.Units[pUnit:GetUnitType()].UnitType;
		ExposedMembers.MOD_CheatMenu.OnDuplicate(ownerID, unitID, unitType, pRelig);
    end
end

function UnitHealChange()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
        ExposedMembers.MOD_CheatMenu.UnitHealChange(ownerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitHealAllChange()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
        ExposedMembers.MOD_CheatMenu.UnitHealAllChange(ownerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitFormCorps()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
        ExposedMembers.MOD_CheatMenu.UnitFormCorps(ownerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitFormArmy()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local ownerID = pUnit:GetOwner();
        ExposedMembers.MOD_CheatMenu.UnitFormArmy(ownerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function MakeFreeCity()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.MakeFreeCity(targetID, ExposedMembers.MOD_CheatMenu.iCity);
    end
end
function FreeBuilder()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.FreeBuilder(targetID, ExposedMembers.MOD_CheatMenu.iCity);
    end
end
function FreeSettler()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.FreeSettler(targetID, ExposedMembers.MOD_CheatMenu.iCity);
    end
end
function ChangeEnvoy()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeEnvoy(targetID, pNewEnvoy);
    end
end

function ChangeDiplomaticFavor()
	local pNewFavor:number = tonumber(Controls.DiploAmount:GetText());
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeDiplomaticFavor(targetID, pNewFavor);
    end
end

function ForceDiplomacy()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ForceDiplomacy(targetID, 100);
    end
end

function RestoreMovement()
	local pUnit = UI.GetHeadSelectedUnit();
	if pUnit ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.RestoreMovement(pUnit:GetOwner(), pUnit:GetID());
	end
end

function KillUnit()
	local pUnit = UI.GetHeadSelectedUnit();
	if pUnit ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.KillUnit(pUnit:GetOwner(), pUnit:GetID());
	end
end

function MakeFreeCityCheat()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() and ExposedMembers.MOD_CheatMenu.iCity then
		ExposedMembers.MOD_CheatMenu.MakeFreeCity(targetID, ExposedMembers.MOD_CheatMenu.iCity);
	end
end

function ToggleControlAll()
	m_ControlOtherCivs = not m_ControlOtherCivs;
	if m_ControlOtherCivs then
		Controls.ControlAllLabel:SetColor(0, 255, 0, 255);
	else
		Controls.ControlAllLabel:SetColor(200, 200, 200, 255);
	end
end
function ChangeGovPoints()
	local targetID = GetCurrentTargetPlayerID();
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeGovPoints(targetID, pNewGP);
    end
end
function RevealAll()
	if pPlayer:IsHuman() then		
		LuaEvents.ChangeFOW(playerID)	
		ExposedMembers.MOD_CheatMenu.RevealAll(playerID);
	end		
end

function RefreshActionPanel()
	if pPlayer:IsHuman() then
		local UPContextPtr :table = ContextPtr:LookUpControl("/InGame/ActionPanel");
		if UPContextPtr ~= nil then
			UPContextPtr:RequestRefresh(); 
		end
	end
	ContextPtr:RequestRefresh(); 
end

-- // ----------------------------------------------------------------------------------------------
-- // HOTKEYS
-- // ----------------------------------------------------------------------------------------------
function OnInputActionTriggered( actionId )
	if ( actionId == Input.GetActionId("ToggleGold") ) then
		ChangeGold();
	end
	if ( actionId == Input.GetActionId("ToggleGoldMore") ) then
		ChangeGoldMore();
	end
	if ( actionId == Input.GetActionId("ToggleFaith") ) then
		ChangeFaith();
	end
	if ( actionId == Input.GetActionId("ToggleCProduction") ) then
		CompleteProduction();
	end
	if ( actionId == Input.GetActionId("ToggleCCivic") ) then
		CompleteCivic();
	end
	if ( actionId == Input.GetActionId("ToggleCResearch") ) then
		CompleteResearch();
	end
	if ( actionId == Input.GetActionId("ToggleEnvoy") ) then
		ChangeEnvoy();
	end
	if ( actionId == Input.GetActionId("ToggleEra") ) then
		ChangeEraScore();
	end
	if ( actionId == Input.GetActionId("ToggleObs") ) then
		RevealAll();
	end
	if ( actionId == Input.GetActionId("ToggleUnitMovementChange") ) then
		UnitMovementChange();
	end
	if ( actionId == Input.GetActionId("ToggleUnitHealChange") ) then
		UnitHealChange();
	end
		if ( actionId == Input.GetActionId("ToggleUnitHealChange") ) then
		UnitHealAllChange();
	end
	if ( actionId == Input.GetActionId("ToggleUnitPromote") ) then
		UnitPromote();
	end
	if ( actionId == Input.GetActionId("ToggleDuplicate") ) then
		OnDuplicateUnit();
	end
	if ( actionId == Input.GetActionId("ToggleChangePopulation") ) then
		ChangePopulation();
	end
	if ( actionId == Input.GetActionId("ToggleChangeCityLoyalty") ) then
		ChangeCityLoyalty();
	end
	if ( actionId == Input.GetActionId("ToggleCompleteAllResearch") ) then
		CompleteAllResearch();
	end
	if ( actionId == Input.GetActionId("ToggleCompleteAllCivic") ) then
		CompleteAllCivic();
	end
	if ( actionId == Input.GetActionId("ToggleMenu") ) then
		OnMenuButtonToggle();
	end
	if ( actionId == Input.GetActionId("ToggleDiplomaticFavor") ) then
		ChangeDiplomaticFavor();
	end
end


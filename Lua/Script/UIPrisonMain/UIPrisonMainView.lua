local PrisonMain = {
  self = nil,
  Img_Mask = nil,
  Img_ = nil,
  Img_TopBG = nil,
  Img_ = nil,
  Btn_Left = nil,
  Btn_Light = nil,
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = nil,
    Btn_Help = {
      self = nil,
      Img_Tips = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    }
  },
  Group_Top = {
    self = nil,
    Group_PrisonIcon = {
      self = nil,
      Btn_Logo = nil,
      Txt_Workshop = nil,
      Txt_LV = nil,
      Group_ = {
        self = nil,
        Txt_Num = nil,
        Img_RedDot = nil
      }
    },
    Group_WorkshopInfo = {
      self = nil,
      Img_WorkshopIcon = nil,
      Txt_WorkshopName = nil,
      Txt_Workshop = nil
    },
    Group_Monitor = {
      self = nil,
      Txt_MonitorName = nil,
      Txt_MonitorDescribe = nil,
      Group_Avatar = {
        self = nil,
        Img_AvatarMask = nil,
        Img_AvatarFrame = {
          self = nil,
          Img_Mask = {self = nil, Img_Avatar = nil}
        },
        Btn_Avatar = nil
      }
    },
    Group_PrisonDetails = {
      self = nil,
      Img_BG = nil,
      Group_Safety = {
        self = nil,
        Txt_Safety = nil,
        Txt_SafetyNum = nil
      },
      Group_Stability = {
        self = nil,
        Txt_Stability = nil,
        Txt_StabilityNum = nil
      },
      Group_Obedience = {
        self = nil,
        Txt_Obedience = nil,
        Txt_ObedienceNum = nil
      },
      Group_Hygiene = {
        self = nil,
        Txt_Hygiene = nil,
        Txt_HygieneNum = nil
      }
    },
    Group_TotalNum = {
      self = nil,
      Txt_TotalNum = nil,
      Txt_TotalNumCount = nil,
      Img_Worker = nil
    },
    Group_TotalEffect = {
      self = nil,
      Txt_TotalNum = nil,
      Txt_TotalNumCount = nil,
      Txt_NoNumCount = nil,
      Img_Worker = nil
    }
  },
  Btn_PrisonManage = {
    self = nil,
    Txt_ = nil,
    PrisonManageGlow = nil
  },
  Group_Windows = {
    self = nil,
    Btn_ = nil,
    Img_QuickJumpBG = {self = nil, Txt_Title = nil},
    ScrollGrid_QuickJump = {
      self = nil,
      grid = {
        self = nil,
        Group_Lock = {
          self = nil,
          Img_ = nil,
          Txt_0 = nil,
          Txt_WorkShop = nil,
          Txt_Tips = nil
        },
        Group_Workshop = {
          self = nil,
          Img_ = nil,
          Txt_0 = nil,
          Txt_WorkShop = nil,
          Txt_Tips = nil
        },
        Img_Pick = nil,
        Btn_ = nil
      }
    }
  },
  Btn_Warehouse = {self = nil, Txt_ = nil},
  Btn_QuickJump = {self = nil, Txt_ = nil},
  Btn_Order = {self = nil, Txt_ = nil},
  Group_ProductionBtn = {
    self = nil,
    Btn_PrisonEdit = {
      self = nil,
      Txt_ = nil,
      Img_RedPoint = nil
    },
    Btn_PrisonProduct = {
      self = nil,
      Txt_ = nil,
      Img_RedPoint = nil
    },
    Btn_WorkshopFaster = {self = nil, Txt_ = nil},
    Btn_BatchGet = {
      self = nil,
      Txt_ = nil,
      Btn_Get = {
        self = nil,
        Img_Get = nil,
        Img_ = nil,
        Txt_ = nil
      }
    }
  },
  Group_Navigation = {
    self = nil,
    Btn_Quest = {self = nil, Txt_Name = nil},
    Btn_Navigation = {self = nil, Txt_Target = nil},
    Img_RedPoint = nil
  },
  Group_AllBtn = {
    self = nil,
    Btn_AllMedical = {
      self = nil,
      Txt_ = nil,
      Txt_NUm = nil
    },
    Btn_AllEvent = {
      self = nil,
      Txt_ = nil,
      Txt_NUm = nil
    }
  }
}
return PrisonMain

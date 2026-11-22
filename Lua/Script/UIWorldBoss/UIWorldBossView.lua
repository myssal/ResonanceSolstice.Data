local WorldBoss = {
  self = nil,
  Img_BG = nil,
  Group_BossNormal = {
    self = nil,
    Img_Bg = nil,
    Spine_Boss = nil,
    Img_Name = nil,
    Img_BarBg = nil,
    Img_Bar = nil,
    Img_HpNumBg = nil,
    Txt_Progress = nil,
    Txt_Name = nil,
    Btn_Detail = nil,
    Btn_Boss = {self = nil, Img_Line = nil},
    Group_Win = {
      self = nil,
      Img_Win = nil,
      Img_Line = nil,
      Txt_T = nil,
      Txt_T2 = nil
    }
  },
  StaticGrid_Normal = {
    self = nil,
    grid = {
      self = nil,
      Img_Bg = nil,
      Spine_Boss = nil,
      Img_Name = nil,
      Img_BarBg = nil,
      Img_Bar = nil,
      Img_HpNumBg = nil,
      Txt_Progress = nil,
      Txt_Name = nil,
      Btn_Detail = nil,
      Btn_Boss = {self = nil, Img_Line = nil},
      Group_Win = {
        self = nil,
        Img_Win = nil,
        Img_Line = nil,
        Txt_T = nil,
        Txt_T2 = nil
      }
    }
  },
  Group_BossFinal = {
    self = nil,
    Img_Bg = nil,
    Spine_Boss = nil,
    Img_Name = nil,
    Img_BarBg = nil,
    Img_Bar = nil,
    Img_HpNumBg = nil,
    Txt_Progress = nil,
    Txt_Name = nil,
    Btn_Detail = nil,
    Btn_Boss = nil,
    Group_Lock = {self = nil, Img_Lock = nil},
    Group_Win = {
      self = nil,
      Img_Win = nil,
      Txt_T = nil,
      Txt_T2 = nil
    },
    Btn_Reward = {self = nil, Txt_ = nil}
  },
  StaticGrid_Final = {
    self = nil,
    grid = {
      self = nil,
      Img_Bg = nil,
      Spine_Boss = nil,
      Img_Name = nil,
      Img_BarBg = nil,
      Img_Bar = nil,
      Img_HpNumBg = nil,
      Txt_Progress = nil,
      Txt_Name = nil,
      Btn_Detail = nil,
      Btn_Boss = nil,
      Group_Lock = {self = nil, Img_Lock = nil},
      Group_Win = {
        self = nil,
        Img_Win = nil,
        Txt_T = nil,
        Txt_T2 = nil
      },
      Btn_Reward = {self = nil, Txt_ = nil}
    }
  },
  Group_Times = {
    self = nil,
    Img_Bg = nil,
    Txt_Times = nil,
    Txt_T = nil
  },
  Btn_Reward = {
    self = nil,
    Txt_T = nil,
    Img_Red = nil
  },
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
  Group_DetailNormal = {
    self = nil,
    Btn_Return = nil,
    Img_Bg = nil,
    Img_Bg2 = nil,
    Img_Bg3 = nil,
    Img_Bg4 = nil,
    Img_Bg5 = {
      self = nil,
      Img_Tip = nil,
      Txt_T = nil
    },
    Group_Boss = {self = nil, Spine_Boss = nil},
    Img_BarBg = nil,
    Img_Bar = nil,
    Img_RewardsBG = nil,
    Img_1 = nil,
    Btn_Fight = {
      self = nil,
      Txt_T = nil,
      Img_T = nil
    },
    Txt_Name = nil,
    Txt_Grade = nil,
    Txt_hp = nil,
    Txt_Progress = nil,
    Txt_Des = nil,
    Txt_R = nil,
    Txt_Times = nil,
    ScrollGrid_Reward = {
      self = nil,
      grid = {
        self = nil,
        Group_Item = {
          self = nil,
          Btn_Item = nil,
          Img_Bottom = nil,
          Img_Item = nil,
          Img_spAdd = nil,
          Img_Mask = nil,
          Group_Break = {
            self = nil,
            Img_Mask = {self = nil, Img_Face = nil},
            Img_F = nil
          },
          Txt_Num = nil,
          Img_Type01 = nil,
          Img_TimeLeft = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Extra = {
            self = nil,
            Img_bg = {self = nil, Txt_txt = nil}
          },
          Img_Type02 = nil,
          Group_Effect = nil,
          Group_ExtraBuff = {
            self = nil,
            Img_bg = {self = nil, Txt_txt = nil}
          },
          Group_EType = {
            self = nil,
            Img_IconBg = nil,
            Img_Icon = nil
          },
          Group_HairColor = {self = nil, Img_ = nil}
        },
        Group_First = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Group_Allready = {self = nil, Img_ = nil}
      }
    },
    StaticGrid_Level = {
      self = nil,
      grid = {
        self = nil,
        Btn_Level = {
          self = nil,
          Img_Bg = nil,
          Txt_Index = nil,
          Img_Selected = nil
        },
        Group_Lock = {
          self = nil,
          Img_Lock = nil,
          Txt_Index = nil,
          Img_Mask = nil
        }
      }
    },
    Group_BtnLevel = {
      self = nil,
      Btn_Level = {
        self = nil,
        Img_Bg = nil,
        Txt_Index = nil,
        Img_Selected = nil
      },
      Group_Lock = {
        self = nil,
        Img_Lock = nil,
        Txt_Index = nil,
        Img_Mask = nil
      }
    },
    Btn_Close = nil
  },
  Group_DetailFinal = {
    self = nil,
    Btn_Return = nil,
    Img_Bg = nil,
    Img_Bg2 = nil,
    Img_Bg3 = nil,
    Img_Bg4 = nil,
    Img_Bg5 = {
      self = nil,
      Img_Tip = nil,
      Txt_T = nil
    },
    Group_Boss = {self = nil, Spine_Boss = nil},
    Img_BarBg = nil,
    Img_Bar = nil,
    Img_RewardsBG = nil,
    Img_1 = nil,
    Btn_Fight = {
      self = nil,
      Txt_T = nil,
      Img_T = nil
    },
    Txt_Name = nil,
    Txt_Grade = nil,
    Txt_hp = nil,
    Txt_Progress = nil,
    Txt_Des = nil,
    Txt_R = nil,
    Txt_Times = nil,
    ScrollGrid_Reward = {
      self = nil,
      grid = {
        self = nil,
        Group_Item = {
          self = nil,
          Btn_Item = nil,
          Img_Bottom = nil,
          Img_Item = nil,
          Img_spAdd = nil,
          Img_Mask = nil,
          Group_Break = {
            self = nil,
            Img_Mask = {self = nil, Img_Face = nil},
            Img_F = nil
          },
          Txt_Num = nil,
          Img_Type01 = nil,
          Img_TimeLeft = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Extra = {
            self = nil,
            Img_bg = {self = nil, Txt_txt = nil}
          },
          Img_Type02 = nil,
          Group_Effect = nil,
          Group_ExtraBuff = {
            self = nil,
            Img_bg = {self = nil, Txt_txt = nil}
          },
          Group_EType = {
            self = nil,
            Img_IconBg = nil,
            Img_Icon = nil
          },
          Group_HairColor = {self = nil, Img_ = nil}
        },
        Group_First = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Group_Allready = {self = nil, Img_ = nil}
      }
    },
    StaticGrid_Level = {
      self = nil,
      grid = {
        self = nil,
        Btn_Level = {
          self = nil,
          Img_Bg = nil,
          Txt_Index = nil,
          Img_Selected = nil
        },
        Group_Lock = {
          self = nil,
          Img_Lock = nil,
          Txt_Index = nil,
          Img_Mask = nil
        }
      }
    },
    Group_BtnLevel = {
      self = nil,
      Btn_Level = {
        self = nil,
        Img_Bg = nil,
        Txt_Index = nil,
        Img_Selected = nil
      },
      Group_Lock = {
        self = nil,
        Img_Lock = nil,
        Txt_Index = nil,
        Img_Mask = nil
      }
    },
    Btn_Close = nil
  }
}
return WorldBoss

local Team_Cube = {
  self = nil,
  Img_Black = nil,
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = {self = nil, Txt_ = nil},
    Btn_Help = {self = nil, Txt_ = nil}
  },
  Group_Level = {
    self = nil,
    Img_Mask = nil,
    Group_Role = {
      self = nil,
      Group_Off = {self = nil, Img_Bg = nil},
      Group_On = {self = nil, Spine_Role = nil},
      Btn_Click = nil
    },
    Group_Level = {
      self = nil,
      Img_Bg = nil,
      Img_Bg2 = nil,
      Img_Captain = nil,
      Btn_Select = nil,
      Btn_Detail = {
        self = nil,
        Txt_T = nil,
        Img_Icon = nil
      },
      Btn_Auto = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Group_Boss = {
        self = nil,
        Img_Mask = {self = nil, Spine_Head = nil}
      },
      Img_Icon = nil,
      Img_Z = nil,
      StaticGrid_RoleList = {
        self = nil,
        grid = {
          self = nil,
          Group_Off = {self = nil, Img_Bg = nil},
          Group_On = {self = nil, Spine_Role = nil},
          Btn_Click = nil
        }
      },
      Txt_Index = nil,
      Txt_Target = nil,
      Group_Off = {self = nil, Img_Mask = nil}
    },
    Btn_Clear = {
      self = nil,
      Txt_T = nil,
      Img_Icon = nil
    }
  },
  Img_ = nil,
  Group_Select = {
    self = nil,
    Img_Bg = {
      self = nil,
      Img_Icon = nil,
      Img_Icon2 = nil,
      Txt_T = nil
    },
    Group_Check = {
      self = nil,
      Img_Bg = nil,
      Btn_Role = {
        self = nil,
        Group_On = {
          self = nil,
          Img_Bg = nil,
          Txt_T = nil
        },
        Group_Off = {self = nil, Txt_T = nil}
      },
      Btn_Team = {
        self = nil,
        Group_On = {
          self = nil,
          Img_Bg = nil,
          Txt_T = nil
        },
        Group_Off = {self = nil, Txt_T = nil}
      }
    },
    Group_RoleList = {
      self = nil,
      ScrollGrid_RoleList = {
        self = nil,
        grid = {
          self = nil,
          Group_Bg = {
            self = nil,
            Img_0 = nil,
            Img_1 = nil,
            Img_2 = nil
          },
          Img_Head = nil,
          Img_Mask = nil,
          Img_Lv = nil,
          Txt_Lv = nil,
          Group_InTeam = {
            self = nil,
            Img_Team = nil,
            Txt_Team = nil
          },
          Btn_Click = nil,
          Txt_Name = nil
        }
      },
      Img_BtnBg = nil,
      Btn_Level = {
        self = nil,
        Img_DeP = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_DeN = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_AP = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_AN = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Btn_Rarity = {
        self = nil,
        Img_DeP = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_DeN = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_AP = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_AN = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Btn_Time = {
        self = nil,
        Img_DeP = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_DeN = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_AP = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_AN = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Btn_Screen = {
        self = nil,
        Img_N = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_P = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      }
    },
    Group_TeamList = {
      self = nil,
      ScrollGrid_TeamList = {
        self = nil,
        grid = {
          self = nil,
          Img_Bg = nil,
          Txt_Name = nil,
          StaticGrid_Role = {
            self = nil,
            grid = {
              self = nil,
              Img_Mask = {self = nil, Img_Head = nil},
              Img_Circle = nil,
              Group_InTeam = {self = nil, Txt_Team = nil},
              Txt_Lv = nil
            }
          },
          Btn_Click = {
            self = nil,
            Img_Bg = nil,
            Txt_ = nil
          },
          Group_Item = {
            self = nil,
            Img_Mask = {self = nil, Img_Head = nil},
            Img_Circle = nil,
            Group_InTeam = {self = nil, Txt_Team = nil},
            Txt_Lv = nil
          }
        }
      }
    },
    Group_Team = {
      self = nil,
      Img_Bg = nil,
      Txt_Name = nil,
      StaticGrid_Role = {
        self = nil,
        grid = {
          self = nil,
          Img_Mask = {self = nil, Img_Head = nil},
          Img_Circle = nil,
          Group_InTeam = {self = nil, Txt_Team = nil},
          Txt_Lv = nil
        }
      },
      Btn_Click = {
        self = nil,
        Img_Bg = nil,
        Txt_ = nil
      },
      Group_Item = {
        self = nil,
        Img_Mask = {self = nil, Img_Head = nil},
        Img_Circle = nil,
        Group_InTeam = {self = nil, Txt_Team = nil},
        Txt_Lv = nil
      }
    },
    Group_Item = {
      self = nil,
      Group_Bg = {
        self = nil,
        Img_0 = nil,
        Img_1 = nil,
        Img_2 = nil
      },
      Img_Head = nil,
      Img_Mask = nil,
      Img_Lv = nil,
      Txt_Lv = nil,
      Group_InTeam = {
        self = nil,
        Img_Team = nil,
        Txt_Team = nil
      },
      Btn_Click = nil,
      Txt_Name = nil
    },
    Btn_Back = nil
  },
  Btn_Battle = {
    self = nil,
    Img_Bg = nil,
    Img_Icon = nil,
    Txt_Num = nil,
    Txt_T = nil
  },
  Group_RoleTemp = {
    self = nil,
    Group_On = {self = nil, Spine_Role = nil}
  },
  Screen_Chapter = {
    self = nil,
    Btn_BG = {self = nil, Img_ = nil},
    Img_Mask = {self = nil, Img_B = nil},
    Group_Career = {
      self = nil,
      Txt_ = nil,
      Btn_All = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C01 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C02 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C03 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C04 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C05 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C06 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C07 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C08 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_C09 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      }
    },
    Group_Group = {
      self = nil,
      Txt_ = nil,
      Btn_All = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G01 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G02 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G03 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G04 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G05 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G06 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G07 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G08 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_G09 = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      }
    },
    Group_Rarity = {
      self = nil,
      Txt_ = nil,
      Btn_All = {
        self = nil,
        Txt_ = nil,
        Img_Select = nil
      },
      Btn_R01 = {
        self = nil,
        Txt_ = nil,
        Img_ = nil,
        Img_Select = nil
      },
      Btn_R02 = {
        self = nil,
        Txt_ = nil,
        Img_ = nil,
        Img_Select = nil
      },
      Btn_R03 = {
        self = nil,
        Txt_ = nil,
        Img_ = nil,
        Img_Select = nil
      },
      Btn_R04 = {
        self = nil,
        Txt_ = nil,
        Img_ = nil,
        Img_Select = nil
      }
    },
    Btn_OK = {
      self = nil,
      Img_Icon = nil,
      Txt_T = nil
    },
    Btn_Cancel = {
      self = nil,
      Img_Icon = nil,
      Txt_T = nil
    },
    Group_Tips = {
      self = nil,
      Img_Tips = nil,
      Txt_Tips = nil
    }
  }
}
return Team_Cube

local PrisonManage = {
  self = nil,
  Img_BG = nil,
  Img_Mask = nil,
  Img_Blur = nil,
  Img_TopBG = nil,
  Btn_Left = nil,
  Btn_Light = nil,
  Group_Arrow = nil,
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
      Txt_Num = nil
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
      Img_Worker = nil
    }
  },
  Group_WorkerList = {
    self = nil,
    Group_Unit = {
      self = nil,
      Img_UnitBottom = nil,
      Group_Empty = {self = nil, Txt_Empty = nil},
      Group_PrisonerUnplace = {
        self = nil,
        Group_PrisonerEmpty = {
          self = nil,
          Img_PrisonerEmptyNoSign = nil,
          Img_PrisonerEmpty = {self = nil, Btn_ = nil},
          Txt_PrisonerEmpty = nil
        },
        Group_SewingMachine = {
          self = nil,
          Img_SewingMachine = {self = nil, Btn_ = nil},
          Txt_SewingLevel = nil
        },
        Group_Frame = {
          self = nil,
          Img_Frame = nil,
          Img_Gear = nil,
          Txt_WorkTime = nil,
          Txt_Number = nil
        },
        Group_Energy = {self = nil, Img_EnergyEmpty = nil}
      },
      Group_PrisonerPlaced = {
        self = nil,
        Group_SewingMachine = {
          self = nil,
          Img_SewingMachine = {self = nil, Btn_ = nil},
          Txt_SewingLevel = nil
        },
        Img_Prisoner = {self = nil, Btn_ = nil},
        Group_Energy = {
          self = nil,
          Img_EnergyEmpty = nil,
          Img_Energy = nil
        },
        Group_Frame = {
          self = nil,
          Group_CommonFrame = {
            self = nil,
            Img_Frame = nil,
            Img_Gear = nil,
            Txt_WorkTime = nil,
            Txt_Number = nil
          },
          Group_MonitorFrame = {
            self = nil,
            Img_Frame = nil,
            Img_Gear = nil,
            Txt_WorkTime = nil,
            Txt_MonitorPosition = nil
          }
        },
        Group_Character = {
          self = nil,
          Txt_CommonCharacter = nil,
          Txt_MonitorPosition = nil,
          Txt_MonitorCharacter = nil
        }
      }
    },
    StaticGrid_Unit = {
      self = nil,
      grid = {
        self = nil,
        Img_UnitBottom = nil,
        Group_Empty = {self = nil, Txt_Empty = nil},
        Group_PrisonerUnplace = {
          self = nil,
          Group_PrisonerEmpty = {
            self = nil,
            Img_PrisonerEmptyNoSign = nil,
            Img_PrisonerEmpty = {self = nil, Btn_ = nil},
            Txt_PrisonerEmpty = nil
          },
          Group_SewingMachine = {
            self = nil,
            Img_SewingMachine = {self = nil, Btn_ = nil},
            Txt_SewingLevel = nil
          },
          Group_Frame = {
            self = nil,
            Img_Frame = nil,
            Img_Gear = nil,
            Txt_WorkTime = nil,
            Txt_Number = nil
          },
          Group_Energy = {self = nil, Img_EnergyEmpty = nil}
        },
        Group_PrisonerPlaced = {
          self = nil,
          Group_SewingMachine = {
            self = nil,
            Img_SewingMachine = {self = nil, Btn_ = nil},
            Txt_SewingLevel = nil
          },
          Img_Prisoner = {self = nil, Btn_ = nil},
          Group_Energy = {
            self = nil,
            Img_EnergyEmpty = nil,
            Img_Energy = nil
          },
          Group_Frame = {
            self = nil,
            Group_CommonFrame = {
              self = nil,
              Img_Frame = nil,
              Img_Gear = nil,
              Txt_WorkTime = nil,
              Txt_Number = nil
            },
            Group_MonitorFrame = {
              self = nil,
              Img_Frame = nil,
              Img_Gear = nil,
              Txt_WorkTime = nil,
              Txt_MonitorPosition = nil
            }
          },
          Group_Character = {
            self = nil,
            Txt_CommonCharacter = nil,
            Txt_MonitorPosition = nil,
            Txt_MonitorCharacter = nil
          }
        }
      }
    }
  },
  Group_Lock = {
    self = nil,
    Group_Lock = {
      self = nil,
      Group_Mask = {
        self = nil,
        Img_LockBG = nil,
        Txt_UnlockedSpace = nil,
        Txt_UnlockedSpaceE = nil,
        Txt_PrisonLv = nil,
        Group_Num = {
          self = nil,
          Txt_NumLock = nil,
          Txt_NumunLock = nil
        },
        Img_Level = nil,
        Group_Level = {
          self = nil,
          Txt_levelLock = nil,
          Txt_leveunlLock = nil
        },
        Txt_Lock = nil,
        Btn_Lock = {self = nil, Txt_ = nil},
        Effect_InTips = {
          self = nil,
          wenli = nil,
          Kuang = nil
        },
        Effect_UnLock = {
          self = nil,
          liuguang = nil,
          weili_TX = nil,
          weili_TX02 = nil,
          jiesuozi = nil,
          liuguang2 = nil,
          yingzi = nil,
          Particle = {self = nil, lizi = nil}
        }
      }
    },
    StaticGrid_ = {
      self = nil,
      grid = {
        self = nil,
        Group_Mask = {
          self = nil,
          Img_LockBG = nil,
          Txt_UnlockedSpace = nil,
          Txt_UnlockedSpaceE = nil,
          Txt_PrisonLv = nil,
          Group_Num = {
            self = nil,
            Txt_NumLock = nil,
            Txt_NumunLock = nil
          },
          Img_Level = nil,
          Group_Level = {
            self = nil,
            Txt_levelLock = nil,
            Txt_leveunlLock = nil
          },
          Txt_Lock = nil,
          Btn_Lock = {self = nil, Txt_ = nil},
          Effect_InTips = {
            self = nil,
            wenli = nil,
            Kuang = nil
          },
          Effect_UnLock = {
            self = nil,
            liuguang = nil,
            weili_TX = nil,
            weili_TX02 = nil,
            jiesuozi = nil,
            liuguang2 = nil,
            yingzi = nil,
            Particle = {self = nil, lizi = nil}
          }
        }
      }
    }
  },
  Group_Edit = {
    self = nil,
    Img_Warehouse = {self = nil, Img_Wenli = nil},
    Img_Empty = {
      self = nil,
      Img_Left = nil,
      Img_Right = nil
    },
    Img_TakeBack = {
      self = nil,
      Img_TakeBack = nil,
      Txt_ = nil
    },
    Group_BoxBtn = {
      self = nil,
      Img_Mask = {
        self = nil,
        Img_BG = {
          self = nil,
          Txt_Machine = nil,
          Img_Machine = nil,
          Txt_Prisoner = nil,
          Img_Prisoner = nil
        }
      }
    },
    Btn_NormalMachine = {
      self = nil,
      Img_NormalMachineLight = {
        self = nil,
        Img_NormalMachine = nil,
        Txt_NormalMachine = nil
      }
    },
    Group_Machine = {
      self = nil,
      Btn_ChangeMachine = {
        self = nil,
        Txt_Change = nil,
        Img_ = nil,
        Group_MachineList = {
          self = nil,
          Btn_Sewing = {
            self = nil,
            Txt_ = nil,
            Img_ = nil
          }
        }
      },
      Btn_UpMachine = {
        self = nil,
        Txt_ = nil,
        Img_BG = nil,
        Group_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Group_UpMachine = {
        self = nil,
        Img_ = nil,
        Txt_ = nil,
        Img_BG = nil,
        Group_MoneyLack = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Group_LevelLack = {self = nil, Txt_ = nil}
      },
      NewScrollGrid_MachineList = {
        self = nil,
        grid = {
          self = nil,
          Btn_Item = {
            self = nil,
            Img_Bg = nil,
            Img_Pick = nil,
            Txt_Item = nil,
            Img_Item = nil,
            Img_Add = {self = nil, Txt_Expand = nil},
            Img_Prisoner = nil,
            Txt_Num = nil,
            Btn_Tips = nil,
            Txt_Count = nil
          }
        }
      }
    },
    Btn_NormalPrisoner = {
      self = nil,
      Img_NormalMachineLight = {
        self = nil,
        Img_NormalMachine = nil,
        Txt_NormalMachine = nil
      }
    },
    Group_Prisoner = {
      self = nil,
      Btn_Monitor = {
        self = nil,
        Txt_Moitor = nil,
        Img_ = nil
      },
      Btn_Manage = {self = nil, Txt_ = nil},
      Group_PrisonerAdd = {
        self = nil,
        Btn_Jia = nil,
        Img_ = nil,
        Btn_Jian = nil,
        Txt_Num = nil,
        Txt_Gang = nil,
        Txt_NumMax = nil
      },
      NewScrollGrid_PrisonerList = {
        self = nil,
        grid = {
          self = nil,
          Btn_Item = {
            self = nil,
            Group_Prisoner = {
              self = nil,
              Img_Bg = nil,
              Img_Pick = nil,
              Txt_Item = nil,
              Img_Item = nil,
              Txt_Character = nil,
              Txt_Monitor = nil,
              Btn_Tips = nil,
              Txt_Count = nil
            },
            Img_Empty = {self = nil, Txt_Text = nil},
            Img_Add = {self = nil, Txt_Expand = nil}
          }
        }
      }
    },
    Btn_Navigation = {
      self = nil,
      Img_Navigation = nil,
      Txt_Navigation = nil
    },
    Btn_Remove = {
      self = nil,
      Img_Remove = nil,
      Txt_Remove = nil
    },
    Btn_Place = {
      self = nil,
      Img_Place = nil,
      Txt_Place = nil
    },
    Btn_hold = {
      self = nil,
      Txt_hold = nil,
      Img_ = nil
    }
  },
  Group_Windows = {
    self = nil,
    Group_QuickJump = {
      self = nil,
      Img_QuickJump = {self = nil, Txt_QuickJump = nil}
    },
    Img_Base = {
      self = nil,
      StaticGrid_Train = {
        self = nil,
        grid = {
          self = nil,
          Btn_train = {
            self = nil,
            Img_Select = {
              self = nil,
              Img_people = nil,
              Img_Icon = nil,
              Txt_Select = nil
            },
            Img_UnSelect = {
              self = nil,
              Txt_UnSelect = nil,
              Img_Icon = nil
            },
            Img_Empty = {self = nil, Txt_Empty = nil}
          }
        }
      }
    },
    Group_train = {
      self = nil,
      Btn_train = {
        self = nil,
        Img_Select = {
          self = nil,
          Img_people = nil,
          Img_Icon = nil,
          Txt_Select = nil
        },
        Img_UnSelect = {
          self = nil,
          Txt_UnSelect = nil,
          Img_Icon = nil
        },
        Img_Empty = {self = nil, Txt_Empty = nil}
      }
    }
  },
  Btn_Windows = nil,
  Group_Temp = {
    self = nil,
    Img_TrainM = nil,
    Img_TrainP = nil
  },
  Img_Train = nil,
  PrisonerListManage = {
    self = nil,
    Img_Background = nil,
    Group_NoPrison = {
      self = nil,
      Img_ = nil,
      Txt_cn = nil,
      Txt_en = {self = nil, Txt_ = nil}
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
    Btn_Passenger = {
      self = nil,
      Group_Txt = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    },
    Group_TopRightPrison = {
      self = nil,
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
    ScrollGrid_Prison = {
      self = nil,
      grid = {
        self = nil,
        Group_Normal = {
          self = nil,
          Img_bg = nil,
          Img_PickBG = nil,
          Img_Pic = nil,
          Img_Side = nil,
          Txt_Name = nil,
          Txt_State = nil,
          Group_Cost = {
            self = nil,
            Txt_ = nil,
            Img_ = nil,
            Txt_Num = nil
          },
          Group_ID = {
            self = nil,
            Txt_ID = nil,
            Img_Rarity = nil,
            Txt_TitleID = nil
          },
          Group_Personality = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_GoodAt = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Time = {
            self = nil,
            Txt_Title = nil,
            Txt_Num = nil,
            Txt_ = nil
          },
          Group_Skill = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Outcome = {
            self = nil,
            Txt_ = nil,
            Txt_Des = nil
          },
          Group_Energy = {
            self = nil,
            Img_Bar = {self = nil, Img_ = nil},
            Img_Heart = nil,
            Txt_Num = nil
          },
          Group_UnitPick = {
            self = nil,
            Img_UnitPick = nil,
            Txt_ = nil
          }
        },
        Btn_Working = {self = nil, Txt_ = nil},
        Btn_Rest = {self = nil, Txt_ = nil},
        Btn_NoMonitor = {self = nil, Txt_ = nil},
        Btn_Monitor = {self = nil, Txt_ = nil}
      }
    },
    Group_Screen = {
      self = nil,
      Btn_BG = {self = nil, Img_ = nil},
      Img_Mask = {
        self = nil,
        Img_B = nil,
        Img_Bottom = nil
      },
      Group_Working = {
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
        }
      },
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
  },
  Group_UnLockEffect = {
    self = nil,
    Group_Mask = {
      self = nil,
      Img_LockBG = nil,
      Txt_UnlockedSpace = nil,
      Txt_UnlockedSpaceE = nil,
      Txt_PrisonLv = nil,
      Group_Num = {
        self = nil,
        Txt_NumunLock = nil,
        Txt_NumLock = nil
      },
      Img_Level = nil,
      Group_Level = {
        self = nil,
        Txt_levelunLock = nil,
        Txt_levelLock = nil
      },
      Btn_Lock = {self = nil, Txt_ = nil},
      Effect_UnLock = {
        self = nil,
        liuguang = nil,
        weili_TX = nil,
        weili_TX02 = nil,
        jiesuozi = nil,
        liuguang2 = nil,
        yingzi = nil,
        Particle = {self = nil, lizi = nil}
      }
    }
  }
}
return PrisonManage

local PrisonEdit = {
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
      Group_Machine = {
        self = nil,
        Img_Machine = nil,
        Txt_MachineLevel = nil
      },
      Group_PrisonerEmpty = {
        self = nil,
        Group_Frame = {
          self = nil,
          Group_NoSelect = {
            self = nil,
            Img_Frame = nil,
            Img_Gear = nil,
            Txt_WorkTime = nil,
            Txt_Number = nil
          },
          Group_Select = {
            self = nil,
            Img_SelectFrame = nil,
            Img_Gear = nil,
            Txt_WorkTime = nil,
            Txt_Number = nil
          }
        },
        Img_PrisonerEmpty = {self = nil, Btn_ = nil},
        Txt_PrisonerEmpty = nil
      },
      Group_PrisonerPlaced = {
        self = nil,
        Img_Prisoner = {self = nil, Btn_ = nil},
        Group_Frame = {
          self = nil,
          Group_NoSelect = {
            self = nil,
            Img_Frame = nil,
            Img_Gear = nil,
            Txt_WorkTime = nil,
            Group_Monitor = {self = nil, Img_ = nil},
            Txt_Number = nil
          },
          Group_Select = {
            self = nil,
            Img_Frame = nil,
            Img_Gear = nil,
            Txt_WorkTime = nil,
            Group_Monitor = {self = nil, Img_ = nil}
          }
        },
        Group_Character = {
          self = nil,
          Txt_CommonCharacter = nil,
          Txt_MonitorPosition = nil,
          Txt_MonitorCharacter = nil
        }
      },
      Btn_ = nil,
      Group_ProductCondition = {
        self = nil,
        Group_ProductStop = {self = nil, Img_Gear = nil},
        Group_Producting = {self = nil, Img_Gear = nil},
        Group_ProductFinish = {
          self = nil,
          Img_Gear = nil,
          Img_Get = nil
        },
        Img_Item = nil,
        Txt_Num = nil,
        Group_Mask = {
          self = nil,
          Img_Mask = nil,
          Img_Icon = nil,
          Txt_ = nil
        }
      },
      UI_WorkerLeads_01 = {
        self = nil,
        Effect_Select = nil,
        Effect_Leads = nil,
        lizi = {
          self = nil,
          lizi = nil,
          star = nil
        }
      }
    },
    StaticGrid_Unit = {
      self = nil,
      grid = {
        self = nil,
        Img_UnitBottom = nil,
        Group_Machine = {
          self = nil,
          Img_Machine = nil,
          Txt_MachineLevel = nil
        },
        Group_PrisonerEmpty = {
          self = nil,
          Group_Frame = {
            self = nil,
            Group_NoSelect = {
              self = nil,
              Img_Frame = nil,
              Img_Gear = nil,
              Txt_WorkTime = nil,
              Txt_Number = nil
            },
            Group_Select = {
              self = nil,
              Img_SelectFrame = nil,
              Img_Gear = nil,
              Txt_WorkTime = nil,
              Txt_Number = nil
            }
          },
          Img_PrisonerEmpty = {self = nil, Btn_ = nil},
          Txt_PrisonerEmpty = nil
        },
        Group_PrisonerPlaced = {
          self = nil,
          Img_Prisoner = {self = nil, Btn_ = nil},
          Group_Frame = {
            self = nil,
            Group_NoSelect = {
              self = nil,
              Img_Frame = nil,
              Img_Gear = nil,
              Txt_WorkTime = nil,
              Group_Monitor = {self = nil, Img_ = nil},
              Txt_Number = nil
            },
            Group_Select = {
              self = nil,
              Img_Frame = nil,
              Img_Gear = nil,
              Txt_WorkTime = nil,
              Group_Monitor = {self = nil, Img_ = nil}
            }
          },
          Group_Character = {
            self = nil,
            Txt_CommonCharacter = nil,
            Txt_MonitorPosition = nil,
            Txt_MonitorCharacter = nil
          }
        },
        Btn_ = nil,
        Group_ProductCondition = {
          self = nil,
          Group_ProductStop = {self = nil, Img_Gear = nil},
          Group_Producting = {self = nil, Img_Gear = nil},
          Group_ProductFinish = {
            self = nil,
            Img_Gear = nil,
            Img_Get = nil
          },
          Img_Item = nil,
          Txt_Num = nil,
          Group_Mask = {
            self = nil,
            Img_Mask = nil,
            Img_Icon = nil,
            Txt_ = nil
          }
        },
        UI_WorkerLeads_01 = {
          self = nil,
          Effect_Select = nil,
          Effect_Leads = nil,
          lizi = {
            self = nil,
            lizi = nil,
            star = nil
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
    Img_BgDown = nil,
    Img_BgUP = nil,
    Img_BgRight = nil,
    Img_Glass = nil,
    Img_Pointleft = nil,
    Img_English = nil,
    Img_Pointright = nil,
    Img_Logo = nil,
    Img_Bg = nil,
    Btn_ChangeMachine = {
      self = nil,
      Img_ChangeON = {
        self = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Change = nil
        }
      },
      Img_ChangeOFF = {
        self = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Change = nil
        }
      },
      Group_MachineList = {
        self = nil,
        Btn_Sewing = {
          self = nil,
          Txt_ = nil,
          Img_ = nil
        }
      }
    },
    Btn_QuickEdit = {
      self = nil,
      Img_QuickEditON = {
        self = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Quick = nil
        }
      },
      Img_QuickEditOFF = {
        self = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Quick = nil
        }
      },
      Img_RedPoint = nil
    },
    Group_Detail = {
      self = nil,
      Group_MachineInfo = {
        self = nil,
        Group_Machine = {
          self = nil,
          Img_Left = nil,
          Img_bg = nil,
          Img_ = nil,
          Group_EffNode = nil
        },
        Group_Num = {
          self = nil,
          Img_titlebase = {
            self = nil,
            Txt_title = nil,
            Txt_LVNum = nil
          },
          Img_Num = nil,
          Txt_Num = nil,
          Txt_NumData = nil
        },
        Group_Consume = {
          self = nil,
          Group_Item = {
            self = nil,
            Img_NeedBottom = nil,
            Txt_Need = nil,
            Txt_And = nil,
            Txt_Have = nil,
            Group_Item = {
              self = nil,
              Btn_Item = nil,
              Img_Bottom = nil,
              Img_Item = nil,
              Img_Mask = nil,
              Group_Num = {
                self = nil,
                Txt_Need = nil,
                Txt_NeedRed = nil,
                Txt_AND = nil,
                Txt_Have = nil
              }
            }
          },
          StaticGrid_Consume = {
            self = nil,
            grid = {
              self = nil,
              Img_NeedBottom = nil,
              Txt_Need = nil,
              Txt_And = nil,
              Txt_Have = nil,
              Group_Item = {
                self = nil,
                Btn_Item = nil,
                Img_Bottom = nil,
                Img_Item = nil,
                Img_Mask = nil,
                Group_Num = {
                  self = nil,
                  Txt_Need = nil,
                  Txt_NeedRed = nil,
                  Txt_AND = nil,
                  Txt_Have = nil
                }
              }
            }
          }
        },
        Btn_UpMachine = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Group_UpMachine = {
          self = nil,
          Img_ = nil,
          Txt_ = nil,
          Group_LevelLack = {self = nil, Txt_ = nil}
        },
        Group_UpMachineMAX = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_ = nil
        }
      },
      Group_PrisonerInfo = {
        self = nil,
        Img_Line = nil,
        Group_PrisonerInfo = {
          self = nil,
          Group_Empty = {
            self = nil,
            Img_ = nil,
            Txt_Click = nil,
            Img_empty = nil,
            Btn_Empty = nil
          },
          Group_PrisonDetail = {
            self = nil,
            Img_Side = nil,
            Txt_Name = nil,
            Img_BG = nil,
            Img_PrisonerBG = nil,
            Img_pic = nil,
            Img_Timebg = nil,
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
              Txt_TitleID = nil,
              Txt_ = nil
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
              Img_Icon = nil,
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
              Img_ = nil,
              Txt_ = nil,
              Txt_Des = nil
            },
            Group_Btn = {
              self = nil,
              Btn_MonitorDown = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              },
              Btn_Monitor = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              },
              Btn_Change = nil,
              Btn_Down = {self = nil, Txt_ = nil},
              Img_RedPoint = nil
            },
            Img_MonitorFlag = nil,
            Group_Health = {
              self = nil,
              Txt_ = nil,
              Img_Empty = nil,
              Img_Health = nil
            },
            UI_WorkerLeads_02 = {
              self = nil,
              Line_1 = nil,
              Line_2 = nil,
              Line_3 = nil,
              Ring = nil
            }
          }
        }
      },
      Btn_hold = {
        self = nil,
        Group_ = {
          self = nil,
          Img_ = nil,
          Txt_hold = nil
        }
      }
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
        Group_Character = {
          self = nil,
          Btn_Mask = nil,
          Group_Normal = {
            self = nil,
            Img_BG = nil,
            Img_Pic = nil,
            Txt_Name = {self = nil, Text = nil},
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
              Img_ = nil,
              Txt_ = nil,
              Txt_Des = nil
            },
            Group_Workshop = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            },
            Group_Health = {
              self = nil,
              Img_Empty = nil,
              Img_Health = nil,
              Txt_ = nil
            }
          },
          Img_Mask = nil,
          Group_InTeam = {
            self = nil,
            Img_Label = {
              self = nil,
              Txt_Num = nil,
              Txt_ = nil
            }
          },
          Group_CantChoose = {
            self = nil,
            Group_Medical = {
              self = nil,
              Img_Icon = nil,
              Txt_ = nil
            },
            Group_Punish = {
              self = nil,
              Img_Icon = nil,
              Txt_ = nil
            },
            Group_Produce = {
              self = nil,
              Img_Icon = nil,
              Txt_ = nil
            }
          },
          Btn_Item = nil
        }
      }
    },
    Group_Detail = {
      self = nil,
      Img_B = {
        self = nil,
        Img_Black = nil,
        Img_GlassBase = nil,
        Img_BlackBase = nil
      },
      Btn_Confirm = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Btn_All = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Btn_AllCancel = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Group_Prisoner = {
        self = nil,
        Txt_ = nil,
        Img_ = nil,
        Txt_Num = nil
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
        },
        Btn_C10 = {
          self = nil,
          Txt_ = nil,
          Img_Select = nil
        },
        Btn_C11 = {
          self = nil,
          Txt_ = nil,
          Img_Select = nil
        },
        Btn_C12 = {
          self = nil,
          Txt_ = nil,
          Img_Select = nil
        },
        Btn_C13 = {
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
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Confirm = nil
        }
      },
      Btn_Cancel = {
        self = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Cancel = nil
        }
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
return PrisonEdit

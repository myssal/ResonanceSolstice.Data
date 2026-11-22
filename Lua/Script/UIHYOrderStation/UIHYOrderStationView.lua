local HYOrderStation = {
  self = nil,
  Img_B = nil,
  Img_BG = nil,
  Img_BGMask = nil,
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
  Group_NPC = {
    self = nil,
    Img_Role = nil,
    SpineAnimation_Character = nil,
    SpineAnimation_Alpha = nil,
    Img_Dialog = {self = nil, Txt_Talk = nil},
    Img_Name = {self = nil, Txt_Name = nil}
  },
  Img_NPCMask = nil,
  Group_Main = {
    self = nil,
    Btn_Manufacture = {
      self = nil,
      Txt_Name = nil,
      Img_Icon = nil,
      Img_RedPoint = nil
    },
    Btn_Order = {
      self = nil,
      Txt_Name = nil,
      Img_Icon = nil,
      Img_RedPoint = nil
    },
    Btn_Exchange = {
      self = nil,
      Txt_Name = nil,
      Img_Icon = nil,
      Img_RedPoint = nil
    },
    Btn_WeekOrder = {
      self = nil,
      Txt_Name = nil,
      Img_Icon = nil,
      Img_RedPoint = nil,
      Img_Rep = {
        self = nil,
        Txt_Name = nil,
        Img_Icon = nil,
        Img_1 = nil,
        Img_2 = nil,
        Txt_Rep = nil
      }
    },
    Btn_Talk = {
      self = nil,
      Txt_Name = nil,
      Img_Icon = nil,
      Img_RedPoint = {
        self = nil,
        Group_Track_Q = {self = nil, Img_ = nil}
      }
    },
    Group_NpcInfo = {
      self = nil,
      Img_Icon = nil,
      Txt_Title = nil,
      Group_Station = {
        self = nil,
        Img_Icon = nil,
        Txt_Station = nil
      },
      Img_Line = nil
    }
  },
  Group_NpcInfo = {
    self = nil,
    Txt_Title = nil,
    Img_Icon = nil,
    Group_Station = {
      self = nil,
      Img_Icon = nil,
      Txt_Station = nil
    },
    Img_Line = nil
  },
  Group_Reputation = {
    self = nil,
    Btn_Reputation = {self = nil, Img_Click = nil},
    Txt_Grade = nil,
    Txt_Num = nil,
    Img_PBBG = nil,
    Img_PB = nil,
    Img_RedPoint = nil
  },
  Group_Quest = {
    self = nil,
    Img_BG = {
      self = nil,
      Txt_OrderTitle = nil,
      Txt_OrderTitleUp = nil,
      Group_Order = {
        self = nil,
        Txt_Name = nil,
        Txt_TitleRequirement = nil,
        Txt_TitleRequirementEn = nil,
        StaticGrid_Requirements = {
          self = nil,
          grid = {
            self = nil,
            Img_ = nil,
            Txt_Name = nil,
            Txt_Num = nil,
            Btn_ = nil
          }
        },
        Txt_TitleRewards = nil,
        Txt_TitleRewardsEn = nil,
        Img_BGMaterial = nil,
        Txt_MaterialTitle = nil,
        ScrollGrid_Materials = {
          self = nil,
          grid = {
            self = nil,
            Img_ = nil,
            Btn_ = nil,
            Img_Num = {self = nil, Txt_ = nil}
          }
        },
        ScrollGrid_Rewards = {
          self = nil,
          grid = {
            self = nil,
            Img_ = nil,
            Img_Num = {self = nil, Txt_ = nil},
            Btn_ = nil
          }
        },
        Btn_Delete = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Btn_Note = {
          self = nil,
          Img_Note = nil,
          Img_Noted = nil,
          Txt_ = nil
        },
        Btn_Deliver = {
          self = nil,
          Txt_ = nil,
          Txt_En = nil
        },
        Btn_CannotDeliver = {
          self = nil,
          Txt_ = nil,
          Txt_En = nil
        },
        Img_Owned = {
          self = nil,
          Img_ = nil,
          Img_Num = {self = nil, Txt_ = nil}
        }
      },
      Group_NoOrder = {
        self = nil,
        Img_ = nil,
        Img_Tip = {self = nil, Txt_ = nil},
        Txt_NoOrder = nil,
        Txt_NoOrderEn = nil,
        Txt_Time = nil,
        Img_Line1 = nil,
        Img_Line2 = nil,
        Group_Pick = {
          self = nil,
          Img_ = nil,
          Btn_Diamond = {
            self = nil,
            Group_off = {
              self = nil,
              Txt_Times = nil,
              Txt_Num = nil
            },
            Group_On = {
              self = nil,
              Img_Pick = nil,
              Txt_Times = nil,
              Txt_Num = nil,
              Img_ = nil
            },
            Img_Item = nil,
            Txt_Name = nil
          },
          Btn_Item = {
            self = nil,
            Group_off = {
              self = nil,
              Txt_Times = nil,
              Txt_Num = nil
            },
            Group_On = {
              self = nil,
              Img_Pick = nil,
              Txt_Times = nil,
              Txt_Num = nil,
              Img_ = nil
            },
            Img_Item = nil,
            Txt_Name = nil
          },
          Btn_Confirm = {self = nil, Txt_ = nil}
        }
      }
    },
    ScrollGrid_Tab = {
      self = nil,
      grid = {
        self = nil,
        Img_Unknown = {
          self = nil,
          Txt_ = nil,
          Img_Level = {self = nil, Txt_ = nil}
        },
        Group_Known = {
          self = nil,
          Img_Off = nil,
          Img_On = nil,
          Txt_Name = nil,
          Txt_NameEn = nil,
          Img_NoOrder = {
            self = nil,
            Txt_Title = nil,
            Txt_Time = nil
          },
          Img_NoOrderPicked = {
            self = nil,
            Txt_Title = nil,
            Txt_Time = nil
          },
          Img_TabNoted = nil,
          Img_TabOk = nil,
          Img_RedDot = nil,
          Img_Item = nil,
          Btn_ = nil
        }
      }
    },
    Group_Tips = {
      self = nil,
      Img_BG = nil,
      Txt_Tips = nil,
      Img_Icon = nil
    },
    Group_GoldCoin = {
      self = nil,
      Img_BG = nil,
      Btn_GoldCoin = nil,
      Img_Icon = nil,
      Txt_Num = nil,
      Btn_Add = nil
    },
    Group_PrisonLv = {
      self = nil,
      Img_BG = nil,
      Img_Icon = nil,
      Txt_Num = nil
    },
    Btn_Order = {
      self = nil,
      Group_Txt = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    },
    Btn_Warehouse = {self = nil, Txt_ = nil},
    Btn_Produce = {
      self = nil,
      Txt_ = nil,
      Img_RedPoint = nil
    }
  },
  Group_Exchange = {
    self = nil,
    Group_GoldCoin = {
      self = nil,
      Img_BG = nil,
      Btn_GoldCoin = nil,
      Img_Icon = nil,
      Txt_Num = nil,
      Btn_Add = nil
    },
    Group_Middle = {
      self = nil,
      Img_BG = nil,
      Img_Di = nil,
      Group_Title = {
        self = nil,
        Img_Title = nil,
        Txt_Title = nil
      },
      ScrollGrid_List = {
        self = nil,
        grid = {
          self = nil,
          Img_Di = nil,
          Img_Icon = {self = nil, Btn_ = nil},
          Group_Name = {
            self = nil,
            Img_ = nil,
            Txt_Name = nil
          },
          Group_Num = {
            self = nil,
            Img_Bg = nil,
            Img_ = nil,
            Txt_Num = nil
          },
          ScrollGrid_List = {
            self = nil,
            grid = {
              self = nil,
              Img_Empty = nil,
              Group_Cost = {
                self = nil,
                Txt_Have = nil,
                Txt_And = nil,
                Txt_Need = nil
              },
              Group_Item = {
                self = nil,
                Btn_Item = nil,
                Img_Bottom = nil,
                Img_Item = nil,
                Img_Mask = nil,
                Group_Break = {
                  self = nil,
                  Img_Mask = {self = nil, Img_Face = nil},
                  Img_F = nil
                },
                Txt_Num = nil,
                Img_Type01 = nil,
                Img_Type02 = nil,
                Group_EType = {
                  self = nil,
                  Img_IconBg = nil,
                  Img_Icon = nil
                },
                Img_TimeLeft = {
                  self = nil,
                  Img_ = nil,
                  Txt_ = nil
                },
                Group_Extra = {
                  self = nil,
                  Img_bg = {self = nil, Txt_txt = nil}
                },
                Group_Effect = nil
              }
            }
          },
          Group_Time = {
            self = nil,
            Img_ = nil,
            Txt_Time = nil
          },
          Group_Btn = {
            self = nil,
            Group_Can = {
              self = nil,
              Img_ = nil,
              Btn_ = nil
            },
            Group_Not = {
              self = nil,
              Img_ = nil,
              Btn_ = nil
            }
          },
          Group_Extra = {
            self = nil,
            Txt_Num = nil,
            Img_Icon = {self = nil, Btn_ = nil}
          },
          Group_Allready = {
            self = nil,
            Img_ = nil,
            Group_ = {
              self = nil,
              Img_Bg = nil,
              Img_ = nil,
              Txt_ = nil
            }
          }
        }
      }
    }
  },
  Group_WeekOrder = {
    self = nil,
    Img_BG = {
      self = nil,
      Img_Icon = nil,
      Txt_OrderTitle = nil,
      Txt_OrderName = nil,
      Txt_Time = nil,
      Group_Time = {
        self = nil,
        Txt_Time = nil,
        Txt_TimeDay = nil
      },
      Img_RightBG = nil,
      Group_WeekOrder = {
        self = nil,
        Group_target = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Group_Progress = {
          self = nil,
          Img_barbg = nil,
          Img_bar = nil,
          Group_ProgressNum = {
            self = nil,
            Txt_Num = nil,
            Txt_Line = nil,
            Txt_Total = nil
          }
        },
        Group_Material = {
          self = nil,
          Txt_MaterialTitle = nil,
          ScrollGrid_Materials = {
            self = nil,
            grid = {
              self = nil,
              Img_ = nil,
              Btn_ = nil,
              Img_Num = {self = nil, Txt_ = nil}
            }
          }
        },
        Group_CompleteRewards = {
          self = nil,
          Txt_TitleRewards = nil,
          Txt_TitleRewardsEn = nil,
          ScrollGrid_Rewards = {
            self = nil,
            grid = {
              self = nil,
              Img_ = nil,
              Img_Num = {self = nil, Txt_ = nil},
              Btn_ = nil
            }
          }
        },
        Group_PerRewards = {
          self = nil,
          Txt_TitleRewards = nil,
          Txt_TitleRewardsEn = nil,
          ScrollGrid_Rewards = {
            self = nil,
            grid = {
              self = nil,
              Img_ = nil,
              Img_Num = {self = nil, Txt_ = nil},
              Btn_ = nil
            }
          }
        },
        Btn_Note = {
          self = nil,
          Img_Note = nil,
          Img_Noted = nil,
          Txt_ = nil,
          Txt_Delete = nil
        },
        Btn_Deliver = {
          self = nil,
          Txt_ = nil,
          Txt_En = nil
        },
        Btn_CannotDeliver = {
          self = nil,
          Txt_ = nil,
          Txt_En = nil
        },
        Group_Unaccept = {
          self = nil,
          Txt_ = nil,
          Txt_RecommendedLevel = nil,
          Btn_Start = {
            self = nil,
            Txt_ = nil,
            Txt_En = nil
          }
        },
        Img_Owned = {
          self = nil,
          Img_ = nil,
          Img_Num = {self = nil, Txt_ = nil}
        },
        Group_OrderComplete = {
          self = nil,
          Img_ = {
            self = nil,
            Txt_ = nil,
            Img_mask = nil
          }
        },
        Group_TotalRewards = {
          self = nil,
          Txt_Title = nil,
          Txt_Tips = nil,
          Txt_Num = nil,
          Img_ = nil,
          ScrollGrid_Rewards = {
            self = nil,
            grid = {
              self = nil,
              Img_ = nil,
              Img_Num = {self = nil, Txt_ = nil},
              Btn_ = nil,
              Txt_ = nil
            }
          }
        },
        Btn_Get = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Group_Get = {
          self = nil,
          Img_bg = nil,
          Img_ = nil,
          Txt_ = nil,
          Img_mask = nil
        },
        Group_Uncomplete = {
          self = nil,
          Img_bg = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Img_AcceptNum = {
          self = nil,
          Img_Icon = nil,
          Txt_Accept = nil,
          Txt_AcceptNum = nil,
          Txt_ = nil
        }
      }
    },
    ScrollGrid_Tab = {
      self = nil,
      grid = {
        self = nil,
        Img_Off = nil,
        Img_On = nil,
        Txt_Name = nil,
        Img_Item = nil,
        Img_TabNoted = nil,
        Img_TabOk = nil,
        Img_RedDot = nil,
        Btn_ = nil,
        StaticGrid_Star = {self = nil, group_Star = nil},
        Btn_Lock = {self = nil, Txt_ = nil},
        Img_complete = nil
      }
    },
    Group_GoldCoin = {
      self = nil,
      Img_BG = nil,
      Btn_GoldCoin = nil,
      Img_Icon = nil,
      Txt_Num = nil,
      Btn_Add = nil
    },
    Group_PrisonLv = {
      self = nil,
      Img_BG = nil,
      Img_Icon = nil,
      Txt_Num = nil
    },
    Btn_Order = {
      self = nil,
      Group_Txt = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    },
    Btn_Warehouse = {self = nil, Txt_ = nil},
    Btn_Produce = {
      self = nil,
      Txt_ = nil,
      Img_RedPoint = nil
    },
    Group_BuyTips = {
      self = nil,
      Btn_BG = {self = nil, Img_BG = nil},
      Img_SU = nil,
      Img_Mask = {self = nil, Img_B = nil},
      Group_Item = {
        self = nil,
        Btn_Item = nil,
        Img_Bottom = nil,
        Img_Item = nil,
        Img_Mask = nil,
        Group_Break = {
          self = nil,
          Img_Mask = {self = nil, Img_Face = nil},
          Img_F = nil
        },
        Txt_Num = nil,
        Img_Type01 = nil,
        Img_Type02 = nil,
        Img_TimeLeft = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        },
        Group_Extra = {
          self = nil,
          Img_bg = {self = nil, Txt_txt = nil}
        },
        Group_EType = {
          self = nil,
          Img_IconBg = nil,
          Img_Icon = nil
        },
        Group_Effect = nil,
        Group_EType = {
          self = nil,
          Img_IconBg = nil,
          Img_Icon = nil
        }
      },
      Txt_Name = nil,
      Btn_Min = {self = nil, Txt_ = nil},
      Btn_Dec = {self = nil, Txt_ = nil},
      Group_Slider = {
        self = nil,
        Img_Bottom = nil,
        Group_Num = {
          self = nil,
          Txt_Select = nil,
          Txt_ = nil,
          Txt_Possess = nil
        },
        Slider_Value = {
          self = nil,
          Img_Bg = nil,
          Group_Fill = {self = nil, Img_Fill = nil},
          Group_Handle = {self = nil, Img_Handle = nil}
        }
      },
      Btn_Add = {self = nil, Txt_ = nil},
      Btn_Max = {self = nil, Txt_ = nil},
      Btn_Cancel = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Btn_Sale = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Txt_Tips = nil,
      Group_Tips = {
        self = nil,
        Img_Tips = nil,
        Txt_Tips = nil
      }
    }
  }
}
return HYOrderStation

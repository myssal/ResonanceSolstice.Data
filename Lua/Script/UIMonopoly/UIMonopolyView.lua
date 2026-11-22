local Monopoly = {
  self = nil,
  Group_Money = {
    self = nil,
    Img_Money = {
      self = nil,
      Img_ = nil,
      Txt_Num = nil,
      Group_GainMoneyIcon = {
        self = nil,
        GainMoney_Icon = {self = nil, lizi = nil}
      },
      Txt_Animation = nil
    },
    Img_Detail = {
      self = nil,
      Group_Text = {
        self = nil,
        Txt_ = nil,
        Txt_Num = nil,
        Img_ = nil
      },
      StaticGrid_City = {
        self = nil,
        grid = {
          self = nil,
          Txt_ = nil,
          Txt_Num = nil,
          Img_ = nil
        }
      },
      Btn_Clsoe = nil
    },
    Btn_CityMoney = {
      self = nil,
      Img_Icon = nil,
      Txt_ = nil,
      Txt_Num = nil,
      Img_Close = nil,
      Img_Open = nil
    }
  },
  Group_Dice = {
    self = nil,
    Btn_Dice = {
      self = nil,
      Img_Num = {self = nil, Txt_Num = nil}
    },
    Btn_Control = {
      self = nil,
      Img_Num = {self = nil, Txt_Num = nil},
      Txt_0 = nil
    },
    Txt_RemainingSteps = {self = nil, Txt_Num = nil}
  },
  Group_Model = {
    self = nil,
    M_Monopoly_Dice = {
      self = nil,
      M_Monopoly_Dice = nil,
      shaiziDummy = nil
    },
    DirectionalLight = nil
  },
  Group_Tips = {
    self = nil,
    Img_TipsBG = {
      self = nil,
      Group_ = {
        self = nil,
        Img_Yellow = nil,
        Img_Blue = nil
      },
      Txt_ = nil
    }
  },
  Group_ItemBackpack = {
    self = nil,
    Img_Block = nil,
    Img_Mask = nil,
    NewScrollGrid_BuffList = {
      self = nil,
      grid = {
        self = nil,
        Img_Selected = nil,
        Img_BG = nil,
        Img_CountTip = {self = nil, Txt_Count = nil},
        Txt_Name = nil,
        Img_Icon = nil,
        Group_Des = {self = nil, Txt_Des = nil},
        Btn_Select = nil
      }
    },
    StaticGrid_BuffList = {
      self = nil,
      grid = {
        self = nil,
        Img_Selected = nil,
        Img_BG = nil,
        Img_CountTip = {self = nil, Txt_Count = nil},
        Txt_Name = nil,
        Img_Icon = nil,
        Group_Des = {self = nil, Txt_Des = nil},
        Btn_Select = nil
      }
    },
    Btn_Use = {
      self = nil,
      Group_Middle = {
        self = nil,
        Img_Icon = nil,
        Txt_Use = nil
      }
    },
    Img_Count = {
      self = nil,
      Txt_Tip = nil,
      Txt_Present = nil,
      Txt_0 = nil,
      Txt_Max = nil
    },
    Group_ChooseCharacter = {
      self = nil,
      Btn_Close = {
        self = nil,
        Img_Mask = nil,
        Group_Tips = {
          self = nil,
          Img_Tips = nil,
          Txt_Tips = nil
        }
      },
      Img_BG = nil,
      Btn_Cancel = {
        self = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Cancel = nil
        }
      },
      Btn_Confirm = {
        self = nil,
        Group_ = {
          self = nil,
          Img_Icon = nil,
          Txt_Confirm = nil
        }
      },
      Txt_Title = nil,
      StaticGrid_Character = {
        self = nil,
        grid = {
          self = nil,
          Img_Selected = nil,
          Btn_Select = nil,
          Img_HeadBG = {
            self = nil,
            Img_HeadMask = {self = nil, Img_Head = nil}
          },
          Img_Info = {
            self = nil,
            Txt_Name = nil,
            Txt_LV = nil
          }
        }
      }
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
    }
  },
  Group_ItemTest = {
    self = nil,
    Img_BG = nil,
    NewScrollGrid_BuffList = {
      self = nil,
      grid = {
        self = nil,
        Group_Item = {
          self = nil,
          Btn_Item = {
            self = nil,
            Txt_Name = {self = nil, Text = nil},
            Img_Icon = nil,
            Img_Num = {self = nil, Txt_Num = nil}
          }
        }
      }
    },
    Btn_TestClose = {
      self = nil,
      Img_Num = {
        self = nil,
        Txt_Own = nil,
        Group_ = {self = nil, Txt_0 = nil},
        Txt_Max = nil
      },
      Txt_0 = nil
    },
    Img_Count = {
      self = nil,
      Txt_Tip = nil,
      Txt_Present = nil,
      Txt_0 = nil,
      Txt_Max = nil
    },
    Group_SliderBar = {
      self = nil,
      Slider_Scale = {
        self = nil,
        Img_Bg = nil,
        Group_Handle = {self = nil, Img_Handle = nil}
      },
      Img_Enlarge = nil,
      Img_Reduce = nil
    },
    Group_Drag = {
      self = nil,
      Img_Drag = nil,
      Group_BuffInfo = {
        self = nil,
        Img_BG = nil,
        Txt_Name = nil,
        Txt_Info = nil
      }
    }
  },
  Group_ItemHide = {
    self = nil,
    Btn_GridMenu = {self = nil, Txt_0 = nil},
    Btn_DiceDay = {
      self = nil,
      Img_Red = nil,
      Txt_0 = nil
    },
    Btn_UseItem = {self = nil, Txt_0 = nil},
    Btn_Refresh = {self = nil, Txt_0 = nil},
    StaticGrid_BuffBar = {
      self = nil,
      grid = {
        self = nil,
        Btn_Buff = {
          self = nil,
          Img_Icon = nil,
          Img_Num = {
            self = nil,
            Txt_0 = nil,
            Txt_Num = nil
          },
          Img_Time = {
            self = nil,
            Txt_Num = nil,
            Txt_0 = nil
          }
        }
      }
    },
    Group_LV = {
      self = nil,
      Img_BG = {
        self = nil,
        Txt_0 = nil,
        Txt_Num = nil
      },
      Img_Icon = nil,
      Btn_LV = nil
    },
    Group_Target = {
      self = nil,
      Btn_Health = {
        self = nil,
        Group_Alive = {
          self = nil,
          Img_ph = nil,
          Img_HP = {
            self = nil,
            Txt_Alive = nil,
            Txt_0 = nil
          },
          Txt_Title = nil
        },
        Group_Dead = {
          self = nil,
          Img_ph = nil,
          Img_HP = {self = nil, Txt_0 = nil}
        },
        Img_RedPoint = nil
      },
      Group_Num = {
        self = nil,
        Img_BG = nil,
        Img_ph = nil,
        Img_AliveNum = {
          self = nil,
          Txt_Alive = nil,
          Txt_0 = nil,
          Txt_Max = nil
        },
        Txt_Title = nil
      }
    }
  },
  Group_Arrow = {
    self = nil,
    Img_ = nil,
    Btn_UP = nil,
    Btn_Down = nil,
    Btn_Left = nil,
    Btn_Right = nil
  },
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = nil,
    Btn_Help = {
      self = nil,
      Group_Txt = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    }
  },
  Group_GainMoney = {
    self = nil,
    GainMoney = {self = nil, lizi = nil}
  },
  Group_Buff = {
    self = nil,
    Img_Block = nil,
    Img_Mask = nil,
    NewScrollGrid_BuffList = {
      self = nil,
      grid = {
        self = nil,
        Img_BG = nil,
        Img_TimeTip = {self = nil, Txt_Time = nil},
        Img_CountTip = {
          self = nil,
          Txt_0 = nil,
          Txt_Count = nil
        },
        Txt_Name = nil,
        Img_Icon = nil,
        Group_Des = {self = nil, Txt_Des = nil}
      }
    },
    StaticGrid_BuffList = {
      self = nil,
      grid = {
        self = nil,
        Img_BG = nil,
        Img_TimeTip = {self = nil, Txt_Time = nil},
        Img_CountTip = {
          self = nil,
          Txt_0 = nil,
          Txt_Count = nil
        },
        Txt_Name = nil,
        Img_Icon = nil,
        Group_Des = {self = nil, Txt_Des = nil}
      }
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
    }
  },
  Group_DiceItem = {
    self = nil,
    Btn_Quit = nil,
    Img_BG = {
      self = nil,
      Btn_1 = nil,
      Btn_2 = nil,
      Btn_3 = nil,
      Btn_4 = nil,
      Btn_5 = nil,
      Btn_6 = nil,
      Img_Title = nil
    }
  },
  Group_BuffGodTips = {
    self = nil,
    Btn_Close = {self = nil, Img_Mask = nil},
    Group_Show = {
      self = nil,
      Img_ = nil,
      Img_BG2 = nil,
      Img_Circle = nil,
      Img_Txt = nil,
      Img_Bottom = {
        self = nil,
        Txt_Name = nil,
        Txt_Des = nil
      },
      Spine_God = nil,
      Img_God = nil,
      Img_LeftIcon = nil,
      Img_RightIcon = nil,
      Img_BuffDes = {self = nil, Txt_Des = nil}
    },
    Group_Tips = {
      self = nil,
      Img_Tips = nil,
      Txt_Tips = nil
    },
    UI_buffgodtips_01 = {
      self = nil,
      qianbi1 = nil,
      qianbi2 = nil
    }
  },
  Group_BuffGodTipsBad = {
    self = nil,
    Btn_Close = {self = nil, Img_Mask = nil},
    Group_Show = {
      self = nil,
      Img_Circle = nil,
      Img_Txt = nil,
      Img_Bottom = {
        self = nil,
        Txt_Name = nil,
        Txt_Des = nil
      },
      Img_God = nil,
      Spine_God = nil,
      Img_BuffDes = {self = nil, Txt_Des = nil},
      Img_Icon = nil
    },
    Group_Tips = {
      self = nil,
      Img_Tips = nil,
      Txt_Tips = nil
    }
  }
}
return Monopoly

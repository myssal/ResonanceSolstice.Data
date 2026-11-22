local TransitCenter = {
  self = nil,
  Img_Bg = nil,
  Group_Transit = {
    self = nil,
    Btn_Prisoner = {self = nil, Txt_ = nil},
    Btn_PrisonerUnavailable = {self = nil, Txt_ = nil},
    Btn_Goods = {self = nil, Txt_ = nil},
    Btn_GoodsUnavailable = {self = nil, Txt_ = nil},
    Group_Tip = {
      self = nil,
      Img_ = nil,
      Txt_ = nil
    }
  },
  Group_Fleet = {
    self = nil,
    ScrollGrid_ = {
      self = nil,
      grid = {
        self = nil,
        Group_Available = {
          self = nil,
          Img_ = nil,
          Txt_Available = nil,
          Img_Icon = nil
        },
        Group_Transit = {
          self = nil,
          Img_ = nil,
          Img_IconPrisoners = nil,
          Img_IconGoods = nil,
          Txt_StatusDes = nil,
          Group_Departure = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Time = {
            self = nil,
            Txt_TimeNum = nil,
            Img_BarBg = nil,
            Img_BarProcess = nil,
            Txt_Time = nil
          },
          Group_Destination = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          }
        },
        Group_FleetNum = {
          self = nil,
          Group_Locked = {self = nil, Txt_Fleet = nil},
          Group_Unlocked = {
            self = nil,
            Txt_Num = nil,
            Txt_Fleet = nil
          }
        },
        Img_Train = nil,
        Group_Locked = {
          self = nil,
          Img_ = nil,
          Group_Unavailable = {
            self = nil,
            Btn_Unavailable = {self = nil, Txt_ = nil}
          },
          Group_Available = {
            self = nil,
            Btn_Available = {self = nil, Txt_ = nil}
          }
        }
      }
    }
  },
  Group_title = {
    self = nil,
    Txt_ch = nil,
    Txt_lv = nil
  },
  Group_Tip = {
    self = nil,
    Group_Time = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Txt_TipTime = nil
    },
    Group_GoodsCost = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Txt_TipTime = nil
    },
    Group_PrisonerCost = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Txt_TipTime = nil
    },
    Group_FleetMax = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Txt_TipTime = nil
    },
    Group_RouteMax = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Txt_TipTime = nil
    }
  },
  Group_Route = {
    self = nil,
    Img_bg = nil,
    Group_Tip1 = {self = nil, Txt_ = nil},
    ScrollView_ = {
      self = nil,
      Viewport = {
        self = nil,
        Content = {
          self = nil,
          StaticGrid_Locked = {
            self = nil,
            grid = {
              self = nil,
              Img_ = nil,
              Group_placeTxt = {
                self = nil,
                Img_ = nil,
                Txt_ = nil,
                Txt_Current = nil
              },
              Group_Warehouse = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              },
              Group_lock = {
                self = nil,
                Img_bg = nil,
                Img_UnavailableLock = {self = nil, Txt_Unavailable = nil},
                Img_AvailableLock = {self = nil, Txt_Available = nil},
                Btn_ = nil
              }
            }
          },
          Txt_ = nil,
          StaticGrid_Unlocked = {
            self = nil,
            grid = {
              self = nil,
              Img_ = nil,
              Group_placeTxt = {
                self = nil,
                Img_ = nil,
                Txt_ = nil,
                Txt_Current = nil
              },
              Group_Warehouse = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              },
              Group_lock = {
                self = nil,
                Img_bg = nil,
                Img_UnavailableLock = {self = nil, Txt_Unavailable = nil},
                Img_AvailableLock = {self = nil, Txt_Available = nil},
                Btn_ = nil
              }
            }
          }
        }
      }
    },
    Group_Item = {
      self = nil,
      Img_ = nil,
      Group_placeTxt = {
        self = nil,
        Img_ = nil,
        Txt_ = nil,
        Txt_Current = nil
      },
      Group_Warehouse = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Group_lock = {
        self = nil,
        Img_bg = nil,
        Img_UnavailableLock = {self = nil, Txt_Unavailable = nil},
        Img_AvailableLock = {self = nil, Txt_Available = nil},
        Btn_ = nil
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
  },
  Group_TransitGoods = {
    self = nil,
    Img_ = nil,
    Btn_Close = nil,
    Img_Bg = nil,
    Group_PickRoute = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_TitleIcon = nil,
        Txt_SendTitle = nil
      },
      ScrollGrid_ = {
        self = nil,
        grid = {
          self = nil,
          GroupInfo = {
            self = nil,
            Group_Unpicked = {
              self = nil,
              Img_Bg = nil,
              Img_PlaceIcon = nil,
              Group_Name = {
                self = nil,
                Img_place = nil,
                Txt_Name = nil
              }
            },
            Group_Picked = {
              self = nil,
              Img_Bg = nil,
              Img_PlaceIcon = nil,
              Group_Name = {
                self = nil,
                Img_place = nil,
                Txt_Name = nil
              },
              Img_Select = nil
            },
            Btn_Pick = nil
          },
          Group_Unlocked = {
            self = nil,
            Group_Warehouse = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            },
            Group_CapacityVisual = {
              self = nil,
              Img_BG = nil,
              Img_Ratio = nil,
              Txt_Tip = nil,
              Txt_Ratio = nil
            }
          },
          Group_Locked = {
            self = nil,
            Group_Warehouse = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            },
            Group_Mask = {
              self = nil,
              Img_lockBg = nil,
              Txt_Lock = nil
            }
          }
        }
      },
      Group_Des = {
        self = nil,
        Img_ = nil,
        Group_Time = {
          self = nil,
          Txt_Title = nil,
          Img_ = nil,
          Txt_Time = nil
        },
        Group_Cost = {
          self = nil,
          Txt_Title = nil,
          Img_ = nil,
          Txt_Time = nil
        }
      },
      Btn_Confirm = {self = nil, Txt_ = nil},
      Btn_CantConfirm = {self = nil, Txt_ = nil}
    },
    Group_Warehouse = {
      self = nil,
      Txt_Title = nil,
      Img_WarehouseBG = nil,
      Img_Kong = nil,
      Group_Switch = {
        self = nil,
        Group_Material = {
          self = nil,
          Btn_Off = {self = nil, Txt_ = nil},
          Group_On = {
            self = nil,
            Img_MaterialLight = nil,
            Txt_ = nil
          }
        },
        Group_Product = {
          self = nil,
          Group_On = {
            self = nil,
            Img_Productlight = nil,
            Txt_ = nil
          },
          Btn_Off = {self = nil, Txt_ = nil}
        }
      },
      Group_Choose = {
        self = nil,
        Btn_Max = {
          self = nil,
          Group_Off = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_On = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          }
        },
        Btn_Batch = {
          self = nil,
          Group_Off = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_On = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          }
        }
      },
      ScrollGrid_Item = {
        self = nil,
        grid = {
          self = nil,
          Btn_Item = nil,
          Img_Bottom = nil,
          Img_Item = nil,
          Img_Mask = nil,
          Txt_Num = nil,
          Group_Producting = {
            self = nil,
            Img_Producting = nil,
            Txt_ = nil
          },
          Img_Pick = nil
        }
      },
      Group_Cpacity = {
        self = nil,
        Img_ = nil,
        Group_MaterialCapacity = {
          self = nil,
          Img_Space = nil,
          Txt_S = nil,
          Txt_Space = nil,
          Img_PBBG = nil,
          Img_PBAfter = nil,
          Img_PBNow = nil
        },
        Group_DestinationCapacity = {
          self = nil,
          Img_Space = nil,
          Txt_S = nil,
          Txt_Space = nil,
          Img_PBBG = nil,
          Img_PBAfter = nil,
          Img_PBNow = nil
        }
      },
      Group_Batch = {
        self = nil,
        Btn_BG = {self = nil, Img_BG = nil},
        Img_Btm = {self = nil, Img_B = nil},
        Group_Panel = {
          self = nil,
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
          },
          Txt_Name = nil,
          Img_Flat = nil,
          Img_Up = nil,
          Img_Down = nil,
          Txt_Quotation = nil,
          Img_TrendFlat = nil,
          Img_TrendUp = nil,
          Img_TrendDown = nil,
          ScrollView_Describe = {
            self = nil,
            Viewport = {self = nil, Txt_Describe = nil}
          },
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
              Img_Bg = {self = nil, Img_ = nil},
              Group_Fill = {self = nil, Img_Fill = nil},
              Group_Handle = {
                self = nil,
                Img_Handle = {self = nil, Img_Click = nil}
              }
            }
          },
          Btn_Add = {self = nil, Txt_ = nil},
          Btn_Max = {self = nil, Txt_ = nil},
          Group_Gold = {
            self = nil,
            Txt_ = nil,
            Img_Coin = nil,
            Txt_Num = nil
          }
        },
        Btn_Cancel = {
          self = nil,
          Group_ = {
            self = nil,
            Img_Icon = nil,
            Txt_T = nil
          }
        },
        Btn_Confirm = {
          self = nil,
          Group_ = {
            self = nil,
            Img_Icon = nil,
            Txt_T = nil
          }
        }
      }
    },
    Group_Tips = {
      self = nil,
      Img_Tips = nil,
      Txt_Tips = nil
    }
  },
  Group_TransitPrisoners = {
    self = nil,
    Img_ = nil,
    Btn_Close = nil,
    Img_Bg = nil,
    Group_NoPrisoner = {
      self = nil,
      Img_ = nil,
      Txt_cn = nil,
      Txt_en = {self = nil, Txt_ = nil}
    },
    Group_Title = {
      self = nil,
      Img_TitleIcon = nil,
      Txt_SendTitle = nil
    },
    ScrollGrid_Coach = {
      self = nil,
      grid = {
        self = nil,
        Group_Normal = {
          self = nil,
          Img_bg = nil,
          Img_Pic = nil,
          Img_Side = nil,
          Txt_Name = nil,
          Group_Location = {
            self = nil,
            Img_Icon = nil,
            Txt_ = nil
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
            Txt_Des = nil
          }
        },
        Group_Right = {
          self = nil,
          Img_Coach = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Img_Unpicked = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Img_Picked = {
            self = nil,
            Img_ = nil,
            Txt_ = nil,
            Img_ = nil
          }
        },
        Btn_Pick = nil,
        Btn_Release = {self = nil, Txt_ = nil}
      }
    },
    Group_Des = {
      self = nil,
      Img_ = nil,
      Group_Time = {
        self = nil,
        Txt_Title = nil,
        Img_ = nil,
        Txt_Time = nil
      },
      Group_Cost = {
        self = nil,
        Txt_Title = nil,
        Img_ = nil,
        Txt_Time = nil
      },
      Group_PrisonerCapacity = {
        self = nil,
        Img_Space = nil,
        Txt_S = nil,
        Txt_Space = nil,
        Img_PBBG = nil,
        Img_PBAfter = nil,
        Img_PBNow = nil
      }
    },
    Btn_Confirm = {self = nil, Txt_ = nil},
    Btn_All = {self = nil, Txt_ = nil},
    Btn_CantConfirm = {self = nil, Txt_ = nil},
    Group_Tips = {
      self = nil,
      Img_Tips = nil,
      Txt_Tips = nil
    }
  }
}
return TransitCenter

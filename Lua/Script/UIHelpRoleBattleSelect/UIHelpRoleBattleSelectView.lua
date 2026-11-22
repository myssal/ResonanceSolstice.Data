local HelpRoleBattleSelect = {
  self = nil,
  Img_BG = {self = nil, Img_EffectMask = nil},
  Img_HelpRole_bg = {
    self = nil,
    Img_Icon = nil,
    Txt_T = nil,
    Txt_E = nil
  },
  ScrollGrid_CharacterList = {
    self = nil,
    grid = {
      self = nil,
      Btn_Mask = nil,
      Img_Bottom = nil,
      Img_Mask = {self = nil, Img_Character = nil},
      Img_Decorate = nil,
      Group_SkillColor = {
        self = nil,
        Img_SkillBase = nil,
        Group_SkillColor1 = {self = nil, Img_Color = nil},
        Group_SkillColor2 = {self = nil, Img_Color = nil},
        Group_SkillColor3 = {self = nil, Img_Color = nil},
        Group_Locate = {self = nil, Img_Line = nil}
      },
      Txt_Name = nil,
      Group_Trust = {
        self = nil,
        Group_Icon = {
          self = nil,
          Img_TrustIcon = nil,
          Img_TrustTimeBG = nil,
          Img_TrustTime = nil
        },
        Txt_TrustNum = nil
      },
      Txt_LVNum = {self = nil, Txt_LV = nil},
      Img_Selected = {self = nil, Spine_Selected = nil},
      Group_Break = {
        self = nil,
        StaticGrid_BK = {
          self = nil,
          grid = {
            self = nil,
            Img_Off = nil,
            Img_On = nil
          }
        }
      },
      Group_Awake = {self = nil, Img_Awake = nil},
      Group_InTeam = {
        self = nil,
        Img_Mask = nil,
        Img_Label = {self = nil, Txt_ = nil},
        Img_Index1 = {self = nil, Txt_ = nil},
        Img_Index2 = {self = nil, Txt_ = nil},
        Img_Index3 = {self = nil, Txt_ = nil},
        Img_Index4 = {self = nil, Txt_ = nil},
        Img_Index5 = {self = nil, Txt_ = nil}
      },
      Btn_Item = nil
    }
  },
  ScrollGrid_HelpRoleList = {
    self = nil,
    grid = {
      self = nil,
      Img_Bg = nil,
      Img_Mask = {
        self = nil,
        Img_Character = nil,
        Img_Black = nil
      },
      Img_Decorate = nil,
      Group_SkillColor = {
        self = nil,
        Img_SkillBase = nil,
        Group_SkillColor1 = {self = nil, Img_Color = nil},
        Group_SkillColor2 = {self = nil, Img_Color = nil},
        Group_SkillColor3 = {self = nil, Img_Color = nil},
        Group_Locate = {self = nil, Img_Line = nil}
      },
      Txt_Name = nil,
      Txt_LVNum = {self = nil, Txt_LV = nil},
      Group_Break = {
        self = nil,
        StaticGrid_BK = {
          self = nil,
          grid = {
            self = nil,
            Img_Off = nil,
            Img_On = nil
          }
        }
      },
      Group_Awake = {self = nil, Img_Awake = nil},
      Group_InTeam = {
        self = nil,
        Img_Mask = nil,
        Img_Label = {self = nil, Txt_ = nil},
        Img_Index1 = {self = nil, Txt_ = nil},
        Img_Index2 = {self = nil, Txt_ = nil},
        Img_Index3 = {self = nil, Txt_ = nil},
        Img_Index4 = {self = nil, Txt_ = nil},
        Img_Index5 = {self = nil, Txt_ = nil}
      },
      Group_Player = {
        self = nil,
        Txt_Name = nil,
        Txt_LVNum = {self = nil, Txt_LV = nil},
        Txt_Uid = nil,
        Img_Icon = nil,
        Img_Head = {
          self = nil,
          Img_Mask = {self = nil, Img_Character = nil}
        }
      },
      Group_Equip = {
        self = nil,
        Group_Equipment = {
          self = nil,
          Btn_Item = {self = nil, Img_Type = nil},
          Group_Equipment = {
            self = nil,
            Btn_Item = nil,
            Img_Bottom = nil,
            Img_Item = nil,
            Img_Mask = nil,
            Img_Tag = {self = nil, Img_Type = nil},
            Img_Select = nil,
            Txt_EquipmentLevel = nil
          }
        },
        StaticGrid_Equip = {
          self = nil,
          grid = {
            self = nil,
            Btn_Item = {self = nil, Img_Type = nil},
            Group_Equipment = {
              self = nil,
              Btn_Item = nil,
              Img_Bottom = nil,
              Img_Item = nil,
              Img_Mask = nil,
              Img_Tag = {self = nil, Img_Type = nil},
              Img_Select = nil,
              Txt_EquipmentLevel = nil
            }
          }
        }
      },
      Img_Selected = nil,
      Btn_Item = nil
    }
  },
  Group_Detail = {
    self = nil,
    Img_Bg = nil,
    Img_B = {
      self = nil,
      Img_Black = nil,
      Img_GlassBase = nil,
      Img_BlackBase = nil
    },
    Btn_Captain = {
      self = nil,
      Txt_T = nil,
      Img_Icon = nil
    },
    Btn_Check = {
      self = nil,
      Txt_T = nil,
      Img_Icon = nil
    },
    Btn_InTeam = {
      self = nil,
      Txt_T = nil,
      Img_Icon = nil
    },
    Btn_OutTeam = {
      self = nil,
      Txt_T = nil,
      Img_Icon = nil
    },
    Group_Property = {
      self = nil,
      Btn_Attribute = {
        self = nil,
        Img_Health = {self = nil, Txt_Value = nil},
        Img_Attack = {self = nil, Txt_Value = nil},
        Img_Defense = {self = nil, Txt_Value = nil},
        Img_Cri = {self = nil, Txt_Value = nil},
        Img_CriDamage = {self = nil, Txt_Value = nil},
        Img_AtkSpd = {self = nil, Txt_Value = nil},
        Img_AtkRange = {self = nil, Txt_Value = nil},
        Img_Sp = {self = nil, Txt_Value = nil},
        Img_All = nil
      }
    },
    Group_Attribute = {
      self = nil,
      Img_Bg = nil,
      Img_Bg2 = nil,
      StaticGrid_Item = {
        self = nil,
        grid = {
          self = nil,
          Img_Icon = nil,
          Txt_Name = nil,
          Txt_PreNum = nil
        }
      },
      Group_Item = {
        self = nil,
        Img_Icon = nil,
        Txt_Name = nil,
        Txt_PreNum = nil
      }
    },
    Btn_Confirm = {
      self = nil,
      Img_Icon = nil,
      Txt_T = nil
    },
    Group_Card = {
      self = nil,
      Btn_Close_Des = {self = nil, Txt_ = nil},
      StaticGrid_Card = {
        self = nil,
        grid = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Btn_Skill = nil,
          Img_Mask = nil,
          Txt_Name = {self = nil, Text = nil},
          Txt_SkillLV = {self = nil, Txt_Num = nil},
          Group_Cost = {
            self = nil,
            Txt_Cost = nil,
            Txt_Num = nil
          }
        }
      }
    },
    Group_CardDesCharacter = {
      self = nil,
      Btn_Close = {self = nil, Img_ = nil},
      Group_LeaderCondition = {self = nil, Img_Bg = nil},
      Group_Skill = {
        self = nil,
        Img_Bg = nil,
        Group_Content = {
          self = nil,
          Group_UP = {
            self = nil,
            Group_Skill = {
              self = nil,
              Img_Skill_Bg = nil,
              Img_Item = nil,
              Txt_Des_Leader = nil,
              Txt_Name = nil,
              Txt_Lv = nil,
              Txt_LvNum = nil,
              Txt_Des = nil,
              Txt_Des_Dmg = nil
            },
            Group_Type = {
              self = nil,
              Img_Bg = nil,
              Txt_Type = nil
            },
            Group_Cost = {
              self = nil,
              Txt_Cost = nil,
              Txt_CostNum = nil
            }
          },
          Group_DownTag = {
            self = nil,
            Group_Tag1 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            },
            Group_Tag2 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            },
            Group_Tag3 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            },
            Group_Tag4 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            },
            Group_Tag5 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            },
            Group_Tag6 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            },
            Group_Tag7 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            },
            Group_Tag8 = {
              self = nil,
              Img_Tag = nil,
              Txt_Tag = nil
            }
          }
        }
      },
      Group_Right = {
        self = nil,
        Group_0 = {
          self = nil,
          Img_Bg = nil,
          Txt_Des = nil,
          Img_Face_Bg = {self = nil, Img_Face = nil},
          Img_Mask = nil
        },
        Group_1 = {
          self = nil,
          Img_Bg = nil,
          Txt_Des = nil,
          Img_Face_Bg = {self = nil, Img_Face = nil},
          Img_Mask = nil
        },
        Group_2 = {
          self = nil,
          Img_Bg = nil,
          Txt_Des = nil,
          Img_Face_Bg = {self = nil, Img_Face = nil},
          Img_Mask = nil
        },
        Group_3 = {
          self = nil,
          Img_Bg = nil,
          Txt_Des = nil,
          Img_Face_Bg = {self = nil, Img_Face = nil},
          Img_Mask = nil
        },
        Group_4 = {
          self = nil,
          Img_Bg = nil,
          Txt_Des = nil,
          Img_Face_Bg = {self = nil, Img_Face = nil},
          Img_Mask = nil
        },
        Group_5 = {
          self = nil,
          Img_Bg = nil,
          Txt_Des = nil,
          Img_Face_Bg = {self = nil, Img_Face = nil},
          Img_Mask = nil
        },
        Group_6 = {
          self = nil,
          Img_Bg = nil,
          Txt_Des = nil,
          Img_Face_Bg = {self = nil, Img_Face = nil},
          Img_Mask = nil
        }
      },
      ScrollView_Card = {
        self = nil,
        Viewport = {
          self = nil,
          Content = {
            self = nil,
            Group_Content = {
              self = nil,
              Group_UP = {
                self = nil,
                Group_Skill = {
                  self = nil,
                  Img_Skill_Bg = nil,
                  Img_Item = nil,
                  Txt_Des_Leader = nil,
                  Txt_Name = nil,
                  Txt_Lv = nil,
                  Txt_LvNum = nil,
                  Txt_Des = nil,
                  Txt_Des_Dmg = nil
                },
                Group_Type = {
                  self = nil,
                  Img_Bg = nil,
                  Txt_Type = nil
                },
                Group_Cost = {
                  self = nil,
                  Txt_Cost = nil,
                  Txt_CostNum = nil
                }
              },
              Group_DownTag = {
                self = nil,
                Group_Tag1 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag2 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag3 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag4 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag5 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag6 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag7 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag8 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag9 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag10 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag11 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag12 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag13 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag14 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag15 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                },
                Group_Tag16 = {
                  self = nil,
                  Img_Tag = nil,
                  Txt_Tag = nil
                }
              }
            }
          }
        }
      }
    },
    Group_Equip = {
      self = nil,
      StaticGrid_Equip = {
        self = nil,
        grid = {
          self = nil,
          Img_Bg = nil,
          Btn_Equip = {self = nil, Txt_ = nil}
        }
      }
    },
    Btn_Role = {
      self = nil,
      Img_Icon = nil,
      Txt_T = nil
    }
  },
  Common_Filter = {
    self = nil,
    Group_TabBtn = {
      self = nil,
      Btn_Level = {
        self = nil,
        Img_bg = {
          self = nil,
          Img_Arrow = nil,
          Txt_Content = nil
        }
      },
      Btn_Rarity = {
        self = nil,
        Img_bg = {
          self = nil,
          Img_Arrow = nil,
          Txt_Content = nil
        }
      },
      Btn_Time = {
        self = nil,
        Img_bg = {
          self = nil,
          Img_Arrow = nil,
          Txt_Content = nil
        }
      },
      Btn_Screen = {
        self = nil,
        Img_bg = {self = nil, Txt_Content = nil}
      }
    },
    Group_Filter = {
      self = nil,
      Btn_BG = {self = nil, Img_ = nil},
      Img_Mask = {self = nil, Img_Bottom = nil},
      Txt_Title = nil,
      StaticGrid_Title = {self = nil, Txt_Title = nil},
      StaticGrid_1 = {
        self = nil,
        grid = {
          self = nil,
          Btn_Item = {
            self = nil,
            Txt_Content = nil,
            Img_Content = nil,
            Img_Select = nil
          }
        }
      },
      StaticGrid_2 = {
        self = nil,
        grid = {
          self = nil,
          Btn_Item = {
            self = nil,
            Txt_Content = nil,
            Img_Content = nil,
            Img_Select = nil
          }
        }
      },
      StaticGrid_3 = {
        self = nil,
        grid = {
          self = nil,
          Btn_Item = {
            self = nil,
            Txt_Content = nil,
            Img_Content = nil,
            Img_Select = nil
          }
        }
      },
      Txt_Tips = nil,
      Btn_OK = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Btn_Cancel = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      }
    }
  },
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = nil,
    Btn_Help = nil
  },
  Btn_Refresh = {
    self = nil,
    Txt_Time = nil,
    Img_Mask = nil
  }
}
return HelpRoleBattleSelect

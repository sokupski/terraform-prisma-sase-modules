security_rules = {
  terraform-secrule-1 = {
    folder                = "Mobile Users"
    action                = "deny"
    source_user           = ["any"]
    source_hip            = ["any"]
    source_regions        = ["RU"]
    destination_regions   = ["RU"]
    source_addresses      = ["10.10.74.7"]
    source_address_groups = ["compromised machines"]
    destination_edls      = ["Palo Alto Networks - Known malicious IP addresses"]
    service_groups        = ["terraform-shared-service-group-1"]
    description           = "Deny all traffic for specific region RU"
    position              = "pre"
    from                  = ["any"]
    to                    = ["any"]
    category              = ["any"]
    application           = ["any"]
    destination_hip       = ["any"]
    disabled              = false
    log_setting           = "Cortex Data Lake"
    negate_source         = false
    negate_destination    = false
    profile_setting = {
      group = ["best-practice"]
    }
  }
  terraform-secrule-2 = {
    folder                = "Shared"
    action                = "allow"
    source                = ["any"]
    source_user           = ["any"]
    source_addresses      = ["10.10.74.6"]
    source_address_groups = ["compromised machines"]
    source_edls           = ["Palo Alto Networks - Bulletproof IP addresses"]
    destination           = ["any"]
    services              = ["terraform-udp-service-1"]
    description           = "Allow all traffic"
    position              = "post"
    from                  = ["any"]
    to                    = ["any"]
    category              = ["any"]
    application           = ["any"]
  }
}

services = {
  terraform-tcp-service-1 = {
    folder      = "Mobile Users"
    description = "HTTPS on 8443 Service for testing"
    protocol = {
      tcp = {
        port        = "8443"
        source_port = null
        override = {
          halfclose_timeout = 1
          timeout           = 5
          timewait_timeout  = 10
        }
      }
    }
  }
  terraform-udp-service-1 = {
    folder      = "Shared"
    description = "DNS Service for testing"
    protocol = {
      udp = {
        port        = "53"
        source_port = null
        override = {
          timeout = 5
        }
      }
    }
  }
}

service_groups = {
  terraform-shared-service-group-1 = {
    folder      = "Shared"
    description = "Service Group for testing"
    members     = ["terraform-udp-service-1"]
  }
  terraform-mu-service-group-1 = {
    folder      = "Mobile Users"
    description = "Service Group for testing"
    members     = ["terraform-tcp-service-1"]
  }
}

addresses = {
  terraform-ipnetmask-google-1 = {
    folder      = "Shared"
    description = "Google Primary DNS1"
    ip_netmask  = "8.8.8.8/32"
    tag         = ["red-alert"]
  }
  terraform-ip-range-10-100 = {
    folder      = "Shared"
    description = "Private Range 1"
    ip_range    = "10.100.0.1-10.100.0.240"
    tag         = ["blue-alert"]
  }
  terraform-fqdn-pan = {
    folder      = "Shared"
    description = "PANW"
    fqdn        = "www.paloaltonetworks.com"
    tag         = ["green-block", "blue-alert"]
  }
  terraform-wildcard-pan = { ## Wildcards do not support Tags and Cannot be used in Address Groups
    folder      = "Shared"
    description = "PANW"
    ip_wildcard = "10.100.4.0/0.0.248.255"
  }
}

address_groups = {
  terraform-shared-address-group-1 = {
    folder      = "Shared"
    description = "Address Group for testing"
    members = ["terraform-ipnetmask-google-1", "terraform-ip-range-10-100",
    "terraform-fqdn-pan"]
  }
}

tags = {
  blue-alert = {
    folder   = "Shared"
    comments = "Blue Tag for testing"
    color    = "Blue"
  }
  green-block = {
    folder   = "Shared"
    comments = "Green Tag for testing"
    color    = "Green"
  }
  red-alert = {
    folder   = "Shared"
    comments = "Red Tag for testing"
    color    = "Red"
  }
}

schedules = {
  weekly-schedule-1 = {
    folder      = "Shared"
    description = "Weekly Schedule for testing"
    schedule_type = {
      recurring = {
        weekly = {
          monday    = ["00:00-00:15"]
          wednesday = ["00:00-00:15"]
          friday    = ["00:00-00:15"]
        }
      }
    }
  }
  daily-schedule-1 = {
    folder      = "Shared"
    description = "Daily Schedule for testing"
    schedule_type = {
      recurring = {
        daily = ["01:00-01:45"]
      }
    }
  }
  non-recurring-schedule-1 = {
    folder      = "Shared"
    description = "Non-Recurring Schedule for testing"
    schedule_type = {
      non_recurring = ["2023/03/27@11:15-2023/03/27@12:15"]
    }
  }
}

external_dynamic_lists = {
  terraform-edl-gcp-ipv4-usc = {
    folder = "Shared"
    type = {
      ip = {
        recurring = {
          five_minute = true
        }
        url         = "https://saasedl.paloaltonetworks.com/feeds/gcp/us-central/any/ipv4"
        description = "Google Cloud US Central Any IPv4"
      }
    }
  }
  terraform-edl-gcp-ipv4-use = {
    folder = "Shared"
    type = {
      ip = {
        recurring = {
          daily = {
            at = "01" # between 00-23
          }
        }
        url         = "https://saasedl.paloaltonetworks.com/feeds/gcp/us-east/any/ipv4"
        description = "Google Cloud US East Any IPv4"
      }
    }
  }
  terraform-edl-gh-ipv4 = {
    folder = "Shared"
    type = {
      ip = {
        recurring = {
          hourly = true
        }
        url         = "https://saasedl.paloaltonetworks.com/feeds/github/actions/ipv4"
        description = "Github Actions IPv4"
      }
    }
  }
}

app_override_rules = {
  terraform-app-override-rule-1 = {
    folder      = "Shared"
    description = "App Override Rule for testing ms office 365"
    position    = "post"
    application = "ms-office365"
    from        = ["any"]
    to          = ["any"]
    port        = "443"
    protocol    = "tcp"
  }
}

qos_policy_rules = {
  terraform-qos-policy-rule-1 = {
    folder      = "Shared"
    description = "QoS Policy Rule for testing"
    position    = "pre"
    schedule    = "daily-schedule-1"
    action = {
      class = 1 # DSCP Codes 1-8
    }
  }
  terraform-qos-policy-rule-2 = {
    folder      = "Shared"
    description = "QoS Policy Rule for testing with codepoints"
    position    = "pre"
    schedule    = "daily-schedule-1"
    action = {
      class = 1 # DSCP Codes 1-8
    }
    dscp_tos = {
      codepoints = [
        {
        name = "af-testing-11"
        type = {
          af = {
            codepoint = "af11" # [af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42]
          }
        }
        },
        {
        name = "ef-testing-1"
        type = {
          ef = true
        }
        },
        {
          name = "cs1-testing"
          type = {
            cs = {
              codepoint = "cs7" # [cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7]
            }
          }
        },
        {
          name = "tos1-testing"
            type = {
                tos = {
                codepoint = "cs0" # [cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7]
                }
            }
        }
      ]
    }
  }
}
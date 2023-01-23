
resource "azurerm_public_ip" "pubip" {
  name                = "mypubip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label   = var.team_name

  tags = {
    environment = "staging"
  }
}


resource "azurerm_lb" "azure_lb" {
  name                = "${local.resource_name_prefix}-pub-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = var.tags

  frontend_ip_configuration {
    name                          = "${local.resource_name_prefix}-pub-lb"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "${local.resource_name_prefix}-lb-backendpool"
  loadbalancer_id     = azurerm_lb.azure_lb.id
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.azure_lb.id
  name                = "${local.resource_name_prefix}-lb-health-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 8080
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.azure_lb.id
  name                           = "${local.resource_name_prefix}-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = azurerm_lb.azure_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.lb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "${local.resource_name_prefix}-vmss"
  location            = var.location
  resource_group_name = var.resource_group_name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 50
    max_unhealthy_instance_percent          = 100
    max_unhealthy_upgraded_instance_percent = 100
    pause_time_between_batches              = "PT0S"
  }

  depends_on = [
    azurerm_lb_rule.lb_rule
  ]
  health_probe_id = azurerm_lb_probe.lb_probe.id

  sku {
    name     = var.vmss_sku_name
    tier     = "Standard"
    capacity = 2
  }


    storage_profile_image_reference {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts-gen2"
      version   = "latest"
    }


  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_profile_data_disk {
    lun               = 0
    caching           = "None"
    create_option     = "Empty"
    disk_size_gb      = var.vmss_storage_disk_size
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name_prefix = "${local.resource_name_prefix}-vmss-"
    admin_username       = var.vmss_admin_username
    admin_password = "Ankur12345678"
  }

  os_profile_linux_config {
    disable_password_authentication = false

  }

  network_profile {
    name = var.vmss_network_profile_name
    network_security_group_id = data.azurerm_network_security_group.vmss_nsg.id
    primary = true

    ip_configuration {
      name = var.vmss_network_profile_name
      primary = true
      subnet_id = data.azurerm_subnet.lb_subnet.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.backend_pool.id]
    }

  }
  tags = var.tags
}





/*resource "azurerm_private_dns_a_record" "dns_a_record" {
  name                = var.private_dns_zone_a_record_name
  zone_name           = data.azurerm_private_dns_zone.private_dns.name
  resource_group_name = var.private_dns_zone_resource_group_name
  ttl                 = 3600
  records             = [azurerm_lb.azure_lb.private_ip_address]
}
*/

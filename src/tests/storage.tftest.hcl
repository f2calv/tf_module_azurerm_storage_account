mock_provider "azurerm" {
  override_during = plan

  mock_resource "azurerm_storage_account" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorage"
    }
  }

  mock_resource "azurerm_storage_container" {
    defaults = {
      id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorage/blobServices/default/containers/uploads"
      url = "https://example.com/uploads"
    }
  }

  mock_resource "azurerm_storage_queue" {
    defaults = {
      id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorage/queueServices/default/queues/work-items"
      url = "https://example.com/work-items"
    }
  }

  mock_resource "azurerm_storage_table" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorage/tableServices/default/tables/Documents"
    }
  }
}

variables {
  resource_group_name  = "example-rg"
  storage_account_name = "examplestorage"
}

run "existing_account_defaults" {
  command = plan

  assert {
    condition = (
      azurerm_storage_account.this.account_kind == "StorageV2" &&
      azurerm_storage_account.this.account_tier == "Standard" &&
      azurerm_storage_account.this.account_replication_type == "LRS" &&
      azurerm_storage_account.this.access_tier == "Hot" &&
      azurerm_storage_account.this.shared_access_key_enabled &&
      !azurerm_storage_account.this.allow_nested_items_to_be_public &&
      azurerm_storage_account.this.identity[0].type == "SystemAssigned"
    )
    error_message = "Existing account defaults must be preserved."
  }

  assert {
    condition = alltrue([
      length(azurerm_storage_container.this) == 0,
      length(azurerm_storage_queue.this) == 0,
      length(azurerm_storage_table.this) == 0,
      length(output.container_ids) == 0,
      length(output.container_urls) == 0,
      length(output.queue_ids) == 0,
      length(output.queue_urls) == 0,
      length(output.table_ids) == 0,
    ])
    error_message = "Omitted collections must produce no children and empty output maps."
  }
}

run "populated_keyless_account" {
  command = plan

  variables {
    containers                = ["uploads", "archive", "uploads"]
    queues                    = ["work-items", "work-items-poison"]
    tables                    = ["Documents"]
    shared_access_key_enabled = false
    identity_type             = null
  }

  assert {
    condition = (
      keys(azurerm_storage_container.this) == ["archive", "uploads"] &&
      keys(azurerm_storage_queue.this) == ["work-items", "work-items-poison"] &&
      keys(azurerm_storage_table.this) == ["Documents"] &&
      alltrue([for name, container in azurerm_storage_container.this :
        container.name == name && container.container_access_type == "private" &&
        container.storage_account_id == output.id
      ]) &&
      alltrue([for name, queue in azurerm_storage_queue.this : queue.name == name && queue.storage_account_id == output.id]) &&
      alltrue([for name, table in azurerm_storage_table.this : table.name == name && table.storage_account_id == output.id]) &&
      !azurerm_storage_account.this.shared_access_key_enabled &&
      length(azurerm_storage_account.this.identity) == 0
    )
    error_message = "Collections must deduplicate into private, name-keyed children of the same account without enabling shared keys or identity."
  }

  assert {
    condition = (
      output.container_ids["uploads"] == azurerm_storage_container.this["uploads"].id &&
      output.container_urls["uploads"] == "https://example.com/uploads" &&
      output.queue_ids["work-items"] == azurerm_storage_queue.this["work-items"].id &&
      output.queue_urls["work-items"] == "https://example.com/work-items" &&
      output.table_ids["Documents"] == azurerm_storage_table.this["Documents"].id &&
      endswith(output.table_ids["Documents"], "/tableServices/default/tables/Documents")
    )
    error_message = "Outputs must expose name-keyed ARM IDs and credential-free URLs from their owning resources."
  }
}

run "case_insensitive_table_collision" {
  command = plan

  variables {
    tables = ["A01", "a01"]
  }

  expect_failures = [var.tables]
}

run "valid_names_and_reordered_sets" {
  command = plan

  variables {
    containers = [format("%063d", 0), "a-b", "uploads", "archive"]
    queues     = [format("%063d", 0), "a-0"]
    tables     = ["A01", "B${format("%062d", 0)}"]
  }

  assert {
    condition = (
      azurerm_storage_container.this["uploads"].name == "uploads" &&
      azurerm_storage_container.this["archive"].name == "archive" &&
      length(output.container_ids) == 4 && length(output.queue_ids) == 2 &&
      length(output.table_ids) == 2
    )
    error_message = "Valid 3-63 character names must be accepted and existing addresses must remain name-keyed."
  }
}

run "short_container_name" {
  command = plan
  variables {
    containers = ["ab"]
  }
  expect_failures = [var.containers]
}

run "long_container_name" {
  command = plan
  variables {
    containers = [format("%064d", 0)]
  }
  expect_failures = [var.containers]
}

run "uppercase_container_name" {
  command = plan
  variables {
    containers = ["Uploads"]
  }
  expect_failures = [var.containers]
}

run "consecutive_container_hyphens" {
  command = plan
  variables {
    containers = ["bad--name"]
  }
  expect_failures = [var.containers]
}

run "special_container_name" {
  command = plan
  variables {
    containers = ["$web"]
  }
  expect_failures = [var.containers]
}

run "leading_queue_hyphen" {
  command = plan
  variables {
    queues = ["-work"]
  }
  expect_failures = [var.queues]
}

run "trailing_queue_hyphen" {
  command = plan
  variables {
    queues = ["work-"]
  }
  expect_failures = [var.queues]
}

run "short_queue_name" {
  command = plan
  variables {
    queues = ["ab"]
  }
  expect_failures = [var.queues]
}

run "long_queue_name" {
  command = plan
  variables {
    queues = [format("%064d", 0)]
  }
  expect_failures = [var.queues]
}

run "uppercase_queue_name" {
  command = plan
  variables {
    queues = ["Work"]
  }
  expect_failures = [var.queues]
}

run "consecutive_queue_hyphens" {
  command = plan
  variables {
    queues = ["bad--name"]
  }
  expect_failures = [var.queues]
}

run "numeric_table_prefix" {
  command = plan
  variables {
    tables = ["1Documents"]
  }
  expect_failures = [var.tables]
}

run "short_table_name" {
  command = plan
  variables {
    tables = ["Ab"]
  }
  expect_failures = [var.tables]
}

run "long_table_name" {
  command = plan
  variables {
    tables = ["A${format("%063d", 0)}"]
  }
  expect_failures = [var.tables]
}

run "table_punctuation" {
  command = plan
  variables {
    tables = ["Document-Items"]
  }
  expect_failures = [var.tables]
}

run "reserved_table_name" {
  command = plan
  variables {
    tables = ["TaBlEs"]
  }
  expect_failures = [var.tables]
}

run "file_account_rejects_containers" {
  command = plan
  variables {
    account_kind = "FileStorage"
    account_tier = "Premium"
    containers   = ["uploads"]
  }
  expect_failures = [azurerm_storage_account.this]
}

run "blob_account_rejects_queues" {
  command = plan
  variables {
    account_kind = "BlobStorage"
    queues       = ["work-items"]
  }
  expect_failures = [azurerm_storage_account.this]
}

run "blob_account_rejects_tables" {
  command = plan
  variables {
    account_kind = "BlobStorage"
    tables       = ["Documents"]
  }
  expect_failures = [azurerm_storage_account.this]
}

run "premium_account_rejects_queues" {
  command = plan
  variables {
    account_tier = "Premium"
    queues       = ["work-items"]
  }
  expect_failures = [azurerm_storage_account.this]
}

run "premium_account_rejects_tables" {
  command = plan
  variables {
    account_tier = "Premium"
    tables       = ["Documents"]
  }
  expect_failures = [azurerm_storage_account.this]
}

run "blob_account_accepts_containers" {
  command = plan
  variables {
    account_kind = "BlobStorage"
    containers   = ["uploads"]
  }
  assert {
    condition     = length(output.container_ids) == 1
    error_message = "Blob-only accounts must support private containers without queues or tables."
  }
}

name "mysql"
description "MySQL Install"
run_list(
  "recipe[mysql::server]",
  "recipe[mysql::client]"
)
override_attributes(
  :mysql => {
    #:server_root_password => you can enter in your root password here else its auto generated,
    :tunable => {
      :innodb_buffer_pool_size => "128M",
      :innodb_log_buffer_size => "8M",
      :innodb_log_file_size => "64M",
      :innodb_additional_mem_pool_size => "16M",
      :max_allowed_packet => "128M"
    }
  }
)

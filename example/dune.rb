# This is an example Dune configuration file


client do
  host 'lvh.me'
  port 5222
  cert 'certs/lvh.me.crt'
  key  'certs/lvh.me.key'
  ca_file 'certs/ca-bundle.crt'
end

require 'dune/storage/sequel'
storage :sequel, 'sqlite://dune.db'

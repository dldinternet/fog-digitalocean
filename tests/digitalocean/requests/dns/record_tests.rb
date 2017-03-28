Shindo.tests("Fog::Dns[:digitalocean] | record", ['digitalocean', 'dns']) do

  tests("domains#create").succeeds do
    @domain = Fog::DNS[:digitalocean].domains.create(name: generate_unique_domain, ip_address: '5.5.5.5')
  end

  params = { :name => @domain.name, :type => 'A', :ttl => 3600, :value => ['1.2.3.4'] }

  model_tests(@domain.records, params) do

    # Newly created records should have a change id
    tests("#change_id") do
      returns(true) { @instance.change_id != nil }
    end

    # Waits for changes to sync to all Route 53 DNS servers.  Usually takes ~30 seconds to complete.
    tests("#ready? - may take a minute to complete...").succeeds do
      @instance.wait_for { ready? }
    end

    tests("#modify") do
      new_value = ['5.5.5.5']
      returns(true) { @instance.modify(:value => new_value) }
      returns(new_value) { @instance.value }
    end

  end

  tests("domains#destroy").succeeds do
    @domain.destroy
  end

end

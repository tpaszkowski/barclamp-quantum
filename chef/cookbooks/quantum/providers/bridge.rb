
action :create do
  
  case new_resource.type
  when "linuxbridge"
    updated = false
    bridge_name = "brq" + ::Quantum.get_net_id_by_name(new_resource.network_name)[0,11]
    unless ::Nic.exists?(bridge_name):
      ::Nic::Bridge.create(bridge_name)
      updated = true
    end
    bridge = ::Nic.new(bridge_name)
    new_resource.slaves.each do |slave|
      unless bridge.slaves.member?(slave):
        bridge.usurp(slave)
        bridge.add_slave(slave)
        updated = true
      end
    end
    new_resource.updated_by_last_action(updated)
  end

end

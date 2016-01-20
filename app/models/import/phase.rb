class Import::Phase

  def self.import(orig_data)
    data = {}
    data["dwd_phase_id"] = orig_data["phasen_id"]
    data["name"] = orig_data["phasenbezeichnung"]

    if (data["dwd_phase_id"].to_i > 0)
      phase = Phase.where(dwd_phase_id: data["dwd_phase_id"]).first_or_create(data)
      print "#{phase.name}, "
    end
  end
end

class Season < ActiveRecord::Base

  enum season: [ :vorfrühling, :erstfrühling, :vollfrühling,
                 :frühsommer, :hochsommer, :spätsommer,
                 :frühherbst, :vollherbst, :spätherbst, :winter ]
end

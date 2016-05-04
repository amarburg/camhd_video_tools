

FFMPEG = "ffmpeg"



def mkdir_if_needed( dir )

	directory dir do
		mkdir_p dir unless Dir.exist?( dir )
	end

end

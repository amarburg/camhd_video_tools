
require 'rake'
include Rake::DSL

require 'constants'

class SourceVideo

	attr_reader :name, :video_path, :relapath
	attr_reader :snippet_file

	def initialize( root, video_path )
		@video_path = video_path
		@relapath = video_path.relative_path_from( root )
		@name = relapath.to_s
	end

	def snippet_task( snippet_root )
		@snippet_file = snippet_root.join( relapath )
		mkdir_if_needed( snippet_file.dirname )

		namespace name do
			task :snippet => [snippet_file.dirname, video_path] do
				sh FFMPEG, "-y", "-ss", "12:48", "-i", "#{video_path}", "-ss", "12:49", "-to", "12:59", "-c:v", "prores", "#{snippet_file}"
			end
		end

		name + ":snippet"
	end

	def frames_task( frames_root )
		exit "snippet file not defined yet" unless @snippet_file

		frames_dir = frames_root.join( relapath.sub_ext('') )
		mkdir_if_needed( frames_dir )

		namespace name do
			task :frames => [snippet_file, frames_dir ] do
				sh FFMPEG, "-y", "-i", "#{snippet_file}", "#{frames_dir.join("frame-%04d.png")}"
			end
		end

		name + ":snippet"

	end

end

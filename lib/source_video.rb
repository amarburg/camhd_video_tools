
require 'rake'
include Rake::DSL

require 'constants'

class SourceVideo

	attr_reader :name, :video_path, :relapath
	attr_reader :snippet_file, :frames_dir

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
				sh FFMPEG, "-y", "-ss", "12:48", "-i", "#{video_path}", "-ss", "00:01", "-to", "00:11", '-c','copy', "#{snippet_file}"
			end
		end

		namespace :clean do
			task :frames do
				sh 'rm','-rf',snippet_file.to_s
			end
		end

		name + ":snippet"
	end

	def frames_task( frames_root )
		exit "snippet file not defined yet" unless @snippet_file

		@frames_dir = frames_root.join( relapath.sub_ext('') )
		mkdir_if_needed( frames_dir )

		namespace name do
			task :frames => [snippet_file, frames_dir ] do
				sh FFMPEG, "-y", "-i", "#{snippet_file}", '-vf', 'fps=fps=1', "#{frames_dir.join("frame-%04d.png")}"
			end
		end

		namespace :clean do
			task :frames do
				sh 'rm','-rf',frames_dir.to_s
			end
		end

		name + ":frames"

	end

	def subset_task( subsets_root )
		exit "frames_dir not defined yet" unless @frames_dir

		subsets_dir = subsets_root.join( relapath.sub_ext('') )
		mkdir_if_needed( subsets_dir )

		namespace name do
			task :subsets => [frames_dir, subsets_dir ] do
				Pathname.glob(frames_dir.join( '*.png' )).each { |frame|
					subset_file = subsets_dir.join( frame.basename )

					sh 'convert', frame.to_s, '-crop', '240x350+1680+525', subset_file.to_s
				}
			end
		end

		namespace :clean do
			task :subsets do
				sh 'rm','-rf',subset_dir.to_s
			end
		end

		name + ":subsets"

	end

end

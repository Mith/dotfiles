{ pkgs, lib, ... }:
{
	home.packages = with pkgs; [
		discord
		any-nix-shell
		fd
		ripgrep
		transmission-gtk
		tldr
		gimp
		universal-ctags
		signal-desktop
		pulseeffects-pw
		kitty
		nerdfonts
		gnome-mpv

		swaylock
		swayidle
		wl-clipboard
		alacritty # Alacritty is the default terminal in the config
		flashfocus
	];

	programs.firefox = {
		enable = true;
		enableGnomeExtensions = true;
	};

	programs.neovim = {
		enable = true;
		withNodeJs = true;
		package = pkgs.neovim-nightly;
		plugins = with pkgs.vimPlugins; [ 
			polyglot 
			sleuth 
			base16-vim 
			vim-commentary
			vim-clap
			vista-vim
			vim-repeat
			vim-surround
			vim-vinegar
			rust-vim
			telescope-nvim
			telescope-fzy-native-nvim
			telescope-frecency-nvim
			sql-nvim
			nvim-treesitter
			nvim-treesitter-textobjects
			nvim-dap
			nvim-dap-virtual-text
			plenary-nvim
			popup-nvim
			nvim-lspconfig
			nvim-compe
			lsp-status-nvim
			lualine-nvim
		];

		extraConfig = builtins.readFile ./nvim/init.vim;
	};

	xdg.configFile."nvim/lua".source = nvim/lua;

	programs.git = {
		enable = true;
		userEmail = "simonvoordouw@gmail.com";
		userName = "Simon Voordouw";
	};

	programs.fish = {
		enable = true;
		promptInit = ''
				any-nix-shell fish --info-right | source
		'';
	};

	programs.direnv = {
		enable = true;
		enableNixDirenvIntegration = true;
		enableFishIntegration = true;
		enableBashIntegration = true;
	};

	programs.fzf = {
		enable = true;
		enableFishIntegration = true;
	};

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	wayland.windowManager.sway = {
		enable = true;
		package = null;
		config = {
			modifier = "Mod4";
			terminal = "\${pkgs.kitty}/bin/kitty";
			input."*" = {
				accel_profile = "flat";
				xkb_layout = "us";
				xkb_variant = "dvorak";
			};
			output = {
				DP-1 = {
					pos = "0 0";
					adaptive_sync = "on";
					mode = "2560x1440@144hz";
				};
				DP-2 = {
					pos = "2560 -200";
					transform = "270";
				};
			};
			window.hideEdgeBorders = "smart";
			gaps = {
				smartBorders = "no_gaps";
			};
			keybindings = let
				modifier = "Mod4";
				x_switch = "exec ${pkgs.i3-wk-switch}/bin/i3-wk-switch";
			in lib.mkOptionDefault {
				"${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
				"${modifier}+Shift+q" = "kill";
				"${modifier}+space" = "exec ${pkgs.wofi}/bin/wofi --show drun";
				"${modifier}+1" = "${x_switch} 1";
				"${modifier}+2" = "${x_switch} 2";
				"${modifier}+3" = "${x_switch} 3";
				"${modifier}+4" = "${x_switch} 4";
				"${modifier}+5" = "${x_switch} 5";
				"${modifier}+6" = "${x_switch} 6";
				"${modifier}+7" = "${x_switch} 7";
				"${modifier}+8" = "${x_switch} 8";
				"${modifier}+9" = "${x_switch} 9";
				"${modifier}+0" = "${x_switch} 10";
			};
			modes = {
        "system:  [r]eboot  [p]oweroff  [l]ogout" = {
          r = "exec reboot";
          p = "exec poweroff";
          l = "exit";
          Return = "mode default";
          Escape = "mode default";
        };
        resize = {
          Left = "resize shrink width 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          Return = "mode default";
          Escape = "mode default";
        };
      };
			bars = [];
		};
	};

	programs.waybar = {
		enable = true;
		systemd.enable = true;
		settings = [
			{
				layer = "top";
				modules-left = ["sway/workspaces" "sway/mode"];
				modules-center = ["clock"];
				modules-right = ["tray" "battery" "pulseaudio"];
				modules = {
					battery = {
						format = "{capacity}% {icon}";
						format-icons = ["" "" "" "" ""];
					};
					clock = {
						format = "{:%a, %d. %b  %H:%M}";
					};
					pulseaudio = {
						format = "{icon} {volume}%";
						on-click = "pavucontrol";
					};
					tray = {
						spacing = 12;
					};
				};
			}
		];
		style = ''
		* {
			border: none;
			border-radius: 0;
			/* `otf-font-awesome` is required to be installed for icons */
			font-family: Roboto, Helvetica, Arial, sans-serif;
			font-size: 13px;
			min-height: 23px;
		}

		window#waybar {
			background-color: rgb(0, 0, 0);
			color: #444;
			transition-property: background-color;
		}

		window#waybar.hidden {
			opacity: 0.2;
		}

		/*
		window#waybar.empty {
			background-color: transparent;
		}
		window#waybar.solo {
			background-color: #FFFFFF;
		}
		*/

		window#waybar.termite {
			background-color: #3F3F3F;
		}

		window#waybar.chromium {
			background-color: #000000;
			border: none;
		}

    #workspaces button {
    	padding: 0 5px;
    	background-color: transparent;
    	color: #ffffff;
    }
    
    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    #workspaces button:hover {
    	background: #333;
    	box-shadow: inherit;
    }
    
    #workspaces button.focused {
    	background-color: #444;
    }
    
    #workspaces button.urgent {
    	background-color: #eb4d4b;
    }
    
    #mode {
    	background-color: #64727D;
    }
    
    #clock,
    #battery,
    #cpu,
    #memory,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #custom-media,
    #tray,
    #mode,
    #idle_inhibitor,
    #mpd {
    	padding: 0 10px;
    	margin: 0 4px;
    	color: #ddd;
    }
    
    #clock {
    }
    
    #battery {
    }
    
    #battery.charging {
    }
    
    @keyframes blink {
    	to {
    		background-color: #ffffff;
    		color: #000000;
    	}
    }
    
    #battery.critical:not(.charging) {
    	background-color: #f53c3c;
    	color: #ffffff;
    	animation-name: blink;
    	animation-duration: 0.5s;
    	animation-timing-function: linear;
    	animation-iteration-count: infinite;
    	animation-direction: alternate;
    }
    
    label:focus {
    	background-color: #000000;
    }
    
    #cpu {
    	color: #000000;
    }
    
    #memory {
    }
    
    #backlight {
    }
    
    #network {
    }
    
    #network.disconnected {
    	color: #f53c3c;
    }
    
    #pulseaudio {
    }
    
    #pulseaudio.muted {
    }
    
    #custom-media {
    	background-color: #66cc99;
    	color: #2a5c45;
    	min-width: 100px;
    }
    
    #custom-media.custom-spotify {
    	background-color: #66cc99;
    }
    
    #custom-media.custom-vlc {
    	background-color: #ffa000;
    }
    
    #temperature {
    	background-color: #f0932b;
    }
    
    #temperature.critical {
    	background-color: #eb4d4b;
    }
    
    #tray {
    }
    
    #idle_inhibitor {
    	background-color: #2d3436;
    }
    
    #idle_inhibitor.activated {
    	background-color: #ecf0f1;
    	color: #2d3436;
    }
    
    #mpd {
    	background-color: #66cc99;
    	color: #2a5c45;
    }
    
    #mpd.disconnected {
    	background-color: #f53c3c;
    }
    
    #mpd.stopped {
    	background-color: #90b1b1;
    }
    
    #mpd.paused {
    	background-color: #51a37a;
    }
    '';
	};
	services.gammastep = {
		enable = true;
		provider = "geoclue2";
	};
	programs.mako.enable = true;
}

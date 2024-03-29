# Copyright (C) 2022-2023 Heptazhou <zhou@0h7z.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# [compat]
# julia = "≥ 1.6"

include("base_func.jl")

const website = "https://github.com/0h7z/Snowfox"
const patch_b =
	[
		"linux/assets/tryfix-reslink-fail.patch";
	]
const ahk_zip = "https://github.com/Heptazhou/AutoHotKey/releases/latest/download/ahk.zip"
# https://github.com/Heptazhou/AutoHotKey | v1.1.36.02

function update(dir::String, recursive::Bool = SUBMODULES)
	@info dir recursive
	for (prefix, ds, fs) ∈ walkdir(dir, topdown = false)
		occursin(prefix)(r"\.git\b") && continue
		occursin(prefix)(r"\bsubmodules\b") && !recursive && continue
		cd(prefix) do
			for d ∈ ds
				if (d ∈ ("linux-mar", "winbuild"))
					rm(d, recursive = true)
					continue
				end
			end
			for f ∈ fs
				if (f ∈ patch_b .|> basename)
					rm(f)
					continue
				end
				if (f ≠ ".git") && !endswith(".jl")(f) && !isbinary(f)
					s = readstr(f)
					for p ∈ schemes
						s = replace(s, p...)
					end
					s = replace(s, "\r\n" => "\n")
					s = replace(s, r"^.*\bEXTRA_PATH.*\n"m => "")
					s = replace(s, r"^.*\bLOWERCASE_.*\n"m => "")
					s = replace(s, r"^.*liblowercase.*\n"m => "")
					s = replace(s, r"https://\Kraw\.(github)usercontent(\.com/[^/]+/[^/]+)/", s"\1\2/raw/")
					s = replace(s, r"https://\Ksnowfox(\.net)", s"librewolf\1")
					s = replace(s, r"https://gitlab\.com/\Ksnowfox(-community)", s"librewolf\1")
					s = replace(s, r"https://gitlab\.com/librewolf-community/\S*?\Ksnowfox"i, s"librewolf")
					s = replace(s, r"https://librewolf\.net/\S*?\Ksnowfox"i, s"librewolf")
					s = replace(s, r"WINDOWSSDKDIR=\"(\$MOZBUILD/win-cross/vs).*?\"", s"WINSYSROOT=\"\1\"")
					#
					s = replace(s, "(?<!=['\"])http://(?!www\\.w3\\.org/)", "https://")
					s = replace(s, "(/github\\.com)/ltGuillaume/(Snowfox-Portable)", s"\1/Heptazhou/\2")
					s = replace(s, "apt-get", "apt", "w")
					s = replace(s, "Snowfox Community", "0h7z", "w")
					s = replace(s, "Snowfox Handler", "Snowfox Document", "w")
					s = replace(s, "ubuntu:jammy", "ubuntu:rolling", "w")
					s = replace(s, ("[\t ]+\$", "m"), "")
					s = replace(s, raw"snowfox-{}-{}" => raw"snowfox-v{}-{}")
					s = replace(s, raw"snowfox-$(full_version)" => raw"snowfox-v$(full_version)")
					s = replace(s, raw"snowfox-$(version)" => raw"snowfox-v$(version)")
					s = replace(s, raw"snowfox-$$(cat version)" => raw"snowfox-v$$(cat version)")
					s = replace(s, raw"snowfox-v([^/\s\.]+)\.en-US\.", s"snowfox-\1.en-US.")
					s = replace(s, raw"snowfox-v\$\(full_version\)\.source\.tar\K\.gz", (".zst"))
					s = replace(s, raw"snowfox-v\$\$\(cat version\)-\$\$\(cat source_release\)\.source\.tar\K\.gz", (".zst"))
					if (f ≡ "Makefile") || endswith(".mk")(f)
						p = raw"$(release)"
						s = replace(s, "[ $p -gt 1 ] && echo \"-$p\"" => "[[ $p -ge 1 ]] && echo \"+$p\"")
						s = replace(s, "s/pkg_version/\$(full_version)/g" => "s/pkg_version/v\$(full_version)/g")
						s = replace(s, r"\bfirefox\b" => "snowfox")
						s = replace(s, r"^.*\btryfix-reslink-fail\.patch\b.*\n"m => "")
					end
					if (f ≡ "Makefile")
						p = raw"v$$(cat version)-$$(cat source_release).source.tar.zst"
						s = replace(s, "~/.cargo/bin/" => "")
						s = replace(s, "Build snowfox and it's windows artifact" => "Build Snowfox and its Windows artifact")
						s = replace(s, r"^.*@echo\b.*\[debug\].*\n"m => "")
						s = replace(s, r"^.*\b linux64-nasm &&.*\n"m => "")
						s = replace(s, r"^.*\b linux64-node &&.*\n"m => "")
						s = replace(s, r"^.*\bartifact toolchain\b[^&]*&& \K.$"m => "sleep 10 && \\")
						s = replace(s, r"^.*\blinux64-binutils\b.*\n"m => "")
						s = replace(s, r"^.*\blinux64-cbindgen\b.*\n"m => "")
						s = replace(s, r"^.*\blinux64-dump_syms\b.*\n"m => "")
						s = replace(s, r"^.*\blinux64-rust-cross\b.*\n"m => "")
						s = replace(s, r"^.*\brm -f version source_release\b.*"m => "")
						s = replace(s, r"^.*\bx86_64-linux-gnu\b.*\n(?!\n)"m => "")
						s = replace(s, r"^.*\bx86_64-pc-windows-msvc\b.*\n(?!\n)"m => "")
						s = replace(s,
							"""\nfetch :""" * r"[\S\s]+?" * "\n" *
							"""\tsha256sum -c "snowfox-$p.sha256"\n""",
							"""\nfetch :""" * "\n" *
							"""\tsha256sum -c "snowfox-$p.sha256"\n""" *
							"""\trustup default stable\n""" *
							"""\trustup target add x86_64-pc-windows-msvc\n""", "e") # ~ do not sort this
						s = replace(s,
							"""	\${MAKE} -f assets/artifacts.mk artifacts\n""" * "\n",
							"""	\${MAKE} -f assets/artifacts.mk artifacts\n""" *
							"""	rm -rf /pkg && mkdir /pkg\n""" *
							"""	cp -pt /pkg snowfox-v*.exe snowfox-v*.zip\n""" * "\n", "p") # ~ do not sort this
					end
					if (f ≡ "artifacts.mk")
						p = "Snowfox-Portable"
						q = "snowfox-v\$(full_version)"
						r = """lockPref("browser.privacySegmentation.createdShortcut", true)\\n"""
						s = replace(s, ("/$p/$p.* ") => ("/$p/*.ahk "))
						s = replace(s, r"^.*\bWinUpdater\b.*\n"m => "")
						s = replace(s, r"^wine=\Kwineconsole\b"m => "~/.mozbuild/wine/bin/wine64")
						s = replace(s, raw"&&" * " \\\n\n" => " )\n\n")
						s = replace(s,
							"""	mv work/snowfox work/snowfox\n""" *
							"""	mv work/snowfox/snowfox.exe work/snowfox/snowfox.exe\n""" *
							"""	cp assets/snowfox.ico work/snowfox\n""",
							"""	rm work/snowfox/pingsender.exe\n""" *
							"""	rm work/snowfox/removed-files\n""" *
							"""	cp assets/snowfox.ico work/snowfox\n""", "p") # ~ do not sort this
						s = replace(s,
							r"#\K[^\n]*" * "ahk-tools" * r"[\S\s]*?" *
							"""	( cd work/$q &&""" * r"[\S\s]*?" * ")\n\n",
							"""\n\n\n""" *
							"""	( cd work && git clone https://github.com/Heptazhou/$p )\n""" *
							"""	( cd work && cp $p/*.ahk $p/*.exe $q )\n""" *
							"""	( cd work && curl -LO $ahk_zip )\n""" *
							"""	( cd work && mkdir ahk && cd ahk && unzip -q ../ahk.zip )\n""" *
							"""	( cd work/$q && rm -f -r  Compiler  &&  mkdir  Compiler )\n""" *
							"""	( cd work/$q && cp ../ahk/Compiler/*64-bit.bin Compiler )\n""" *
							"""	( cd work/$q && cp ../ahk/Compiler/Ahk2Exe.exe Compiler )\n""" *
							"""	( cd work/$q && cp ../snowfox/snowfox.ico ./Snowfox.ico )\n""" *
							"""	( cd work/$q && echo -e '$r' \\\n\t> Profiles/Default/snowfox.config.js )""" *
							"""\n\n\n""", "e") # ~ do not sort this
					end
					if (f ≡ "mozconfig")
						p = "ac_add_options"
						s = replace(s,
							"$p --with-app-name=\\w+\n" *
							"$p --with-branding=browser/branding/\\w+\n",
							"$p --with-app-name=snowfox\n" *
							"$p --enable-update-channel=release\n" *
							"$p --with-branding=browser/branding/snowfox\n", "e") # ~ do not sort this
						p = "mk_add_options"
						s = replace(s,
							"$p MOZ_CRASHREPORTER=0\n" *
							"$p MOZ_DATA_REPORTING=0\n" *
							"$p MOZ_NORMANTY=0\n" *
							"$p MOZ_SERVICES_HEALTHREPORT=0\n" *
							"$p MOZ_TELEMETRY_REPORTING=0\n", # ~ do not sort this
							"$p MOZ_CRASHREPORTER=0\n" *
							"$p MOZ_DATA_REPORTING=0\n" *
							"$p MOZ_SERVICES_HEALTHREPORT=0\n" *
							"$p MOZ_TELEMETRY_REPORTING=0\n", "p", n = 1)
						s = replace(s, r"\$MOZBUILD/clang/bin/(?!clang-cl)"m => "/bin/")
						s = replace(s, r"^.*--disable-verify-mar\b.*\n"m => "")
						s = replace(s, r"^# since\b.+\?\n"m => "")
						s = replace(s, r"^export MOZ_REQUIRE_SIGNING=\K1?$"m, '"'^2)
						s = replace(s, r"^export WINE=\Kwineconsole\b"m, s"\"$MOZBUILD/wine/bin/wine64\"")
					end
					if (f ≡ "setup.nsi")
						s = expands(s)
						s = replace(s,
							raw"""SnowfoxHTM\DefaultIcon" "" "$INSTDIR\snowfox.exe,0""",
							raw"""SnowfoxHTM\DefaultIcon" "" "$INSTDIR\snowfox.exe,1""", "w")
					end
					write(f, s)
				end
			end
		end
	end
end

const SUBMODULES = something(tryparse.(Bool, [ARGS; "0"])...)

filter!(!=("/"), ARGS)
if isempty(ARGS)
	(dir, arg) = @__DIR__, pwd()
	update(startswith(arg, dir) ? arg : dir)
else
	(dir, arg) = @__DIR__, abspath.(ARGS[1])
	isdir(arg) || throw(SystemError(arg, 2))
	update(startswith(arg, dir) ? arg : dir)
end


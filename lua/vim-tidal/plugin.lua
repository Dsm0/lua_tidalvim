
function TmuxSend()
  error("TmuxSend not yet implemented")
end


function TmuxPaneNames(A,L,P)
  error("TmuxPaneNames not yet implemented")
end

function TmuxConfig()
  error("TmuxConfig not yet implemented")
end


function TerminalOpen()
  error("TerminalOpen not yet implemented")
end


function TerminalSend(config, text)
  error("TerminalSend not yet implemented")
end


function SID()
  error("SID not yet implemented")
end




function WritePasteFile(text)
  error("WritePasteFile not yet implemented")
end

function _EscapeText(text)
  error("_EscapeText not yet implemented")
end

function TidalGetConfig()
  error("TidalGetConfig not yet implemented")
end

function TidalFlashVisualSelection()
  error("TidalFlashVisualSelection not yet implemented")
end

function TidalSendOp(op_type, ...)
  error("TidalSendOp not yet implemented")
end

function TidalSendRange()
  error("TidalSendRange not yet implemented")
end

function TidalSendLines(count)
  error("TidalSendLines not yet implemented")
end

function TidalStoreCurPos()
  error("TidalStoreCurPos not yet implemented")
end

function TidalRestoreCurPos()
  error("TidalRestoreCurPos not yet implemented")
end

-- let parent_path = fnamemodify(expand("<sfile>"), ":p:h:s?/plugin??")

-- """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- " Public interface
-- """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function TidalSend(text)
  error("TidalSend not yet implemented")
end

function TidalConfig()
  error("TidalConfig not yet implemented")
end

-- " delegation
function TidalDispatch(name, ...)
  error("TidalDispatch not yet implemented")
end

function TidalHush()
  error("TidalHush not yet implemented")
end

function TidalSilence(stream)
  error("TidalSilence not yet implemented")
end

function TidalPlay(stream)
  error("TidalPlay not yet implemented")
end

function TidalGenerateCompletions(path)
  error("TidalGenerateCompletions not yet implemented")
end

--[=====[ 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

-- command -bar -nargs=0 TidalConfig call s:TidalConfig()
-- command -range -bar -nargs=0 TidalSend <line1>,<line2>call s:TidalSendRange()
-- command -nargs=+ TidalSend1 call s:TidalSend(<q-args> . "\r")

-- command! -nargs=0 TidalHush call s:TidalHush()
-- command! -nargs=1 TidalSilence call s:TidalSilence(<args>)
-- command! -nargs=1 TidalPlay call s:TidalPlay(<args>)
-- command! -nargs=? TidalGenerateCompletions call s:TidalGenerateCompletions(<q-args>)

-- noremap <SID>Operator :<c-u>call <SID>TidalStoreCurPos()<cr>:set opfunc=<SID>TidalSendOp<cr>g@

-- noremap <unique> <script> <silent> <Plug>TidalRegionSend :<c-u>call <SID>TidalSendOp(visualmode(), 1)<cr>
-- noremap <unique> <script> <silent> <Plug>TidalLineSend :<c-u>call <SID>TidalSendLines(v:count1)<cr>
-- noremap <unique> <script> <silent> <Plug>TidalMotionSend <SID>Operator
-- noremap <unique> <script> <silent> <Plug>TidalParagraphSend <SID>Operatorip
-- noremap <unique> <script> <silent> <Plug>TidalConfig :<c-u>TidalConfig<cr>

-- ""
-- " Default options
-- "
-- if !exists("g:tidal_target")
--   let g:tidal_target = "tmux"
-- endif

-- if !exists("g:tidal_paste_file")
--   let g:tidal_paste_file = tempname()
-- endif

-- if !exists("g:tidal_default_config")
--   let g:tidal_default_config = { "socket_name": "default", "target_pane": ":0.1" }
-- endif

-- if !exists("g:tidal_preserve_curpos")
--   let g:tidal_preserve_curpos = 1
-- end

-- if !exists("g:tidal_flash_duration")
--   let g:tidal_flash_duration = 150
-- end

-- if filereadable(s:parent_path . "/.dirt-samples")
--   let &l:dictionary .= ',' . s:parent_path . "/.dirt-samples"
-- e
--]=====]

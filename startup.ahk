#SingleInstance force
^'::#^right
^;::#^left
^space::#space
#s::
  send ^s
return
#z::
  send ^z
return
#c::
  send ^c
return
#v::
  send ^v
return
^=::
  send {wheeldown 1}
return
^-::
  send {wheelup 1}
return
!h::
  send {left down}
return
!l::
  send {right down}
return
!j::
  send {down down}
return
!k::
  send {up down}
return

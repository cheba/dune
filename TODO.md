# Prototype

Prototype is meant to be a minimum working product. It focuses on a simple
client use case: connect, add a contact, send a message, receive a message,
remove a contact, disconnect. Prototype is not an implementation of any specific
subset of the spec.

* Accept multiple connections *DONE*
* StartTLS *DONE*
* SASL authentication *DONE (plain)*
* Manage roster
  * Add contacts *DONE*
  * Remove contacts
  * Change contacts *DONE*
* Presence
  * Set status
  * Broadcast presence
* Messaging
  * Route messages

# 1.0

Version 1.0 is meant a full implementation of [XMPP CORE][], [XMPP IM][] and
[XMPP ADDR][] but it may leave out some parts of the spec most modern
clients/servers can leave without. For example, it's not recommended to perform
client authentication on an unencrypted stream, so Dune will require StartTLS
and won't work with clients that try to authenticate user on an unencrypted
stream. There might be some other parts of the spec that are targeted at legacy
clients or that are optional and are not universally supported by the most
popular implementations that will
be skipped for 1.0.


[XMPP CORE]: http://xmpp.org/rfcs/rfc6120.html
[XMPP IM]: http://xmpp.org/rfcs/rfc6121.html
[XMPP ADDR]: http://xmpp.org/rfcs/rfc6122.html

module Dune
  NAMESPACES = {
     stream:    'http://etherx.jabber.org/streams',
     client:    'jabber:client',
     server:    'jabber:server',
     component: 'jabber:component:accept',
     roster:    'jabber:iq:roster',
     sasl:      'urn:ietf:params:xml:ns:xmpp-sasl',
     tls:       'urn:ietf:params:xml:ns:xmpp-tls',
     bind:      'urn:ietf:params:xml:ns:xmpp-bind',
     streams:   'urn:ietf:params:xml:ns:xmpp-streams',
     stanzas:   'urn:ietf:params:xml:ns:xmpp-stanzas',
  }
end


require 'dune/server'

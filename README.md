# JuggApp

JuggApp is a Rails application written to provide a way for people to apply to my guild, [Juggernaut](http://www.juggernautguild.com).

## Customizing For Your Guild

As the application was written specifically and solely for Juggernaut's use, you'll have to make several major changes to it if you want to use it for your own guild.

### Layout

The default application layout uses the skin from our forum in order to fit in with the overall look of our site. You probably want to use your own.

### Login

The application uses a gem I wrote specifically for it called [invision_bridge](http://github.com/tsigo/invision_bridge), which lets Authlogic access an [IP.Board](http://www.invisionpower.com) database and allows users to only have one login for the entire site. I'd recommend either fully implementing the rest of an authentication with Authlogic (sign up, user management, etc.) and making users maintain two separate accounts, or writing a similar gem for your own forum system.

### Region

Juggernaut is on a US server, and people on EU servers aren't allowed to transfer to US servers, so by default we only provide a list of US servers in the server drop-down. It should be trivial to change this to EU.

## Contributing

I'd love to see what other people do with this. Please fork and/or submit tickets!

## Credits

Copyright (c) 2008-2010 Robert Speicher, released under the MIT license

TODO: archiv musí obsahovat readme.txt, kde je popsána adresářová struktura s důrazem
na informaci umístění klíčových částí FE a autorství konkrétních částí,

android/ [Android platform specific settings]
assets/ [Assets like images, fonts, etc.]
docs/ [Requirements, documentation, and related content]
lib/
    backend/ <- Our separate BE layer. Communication is done via non-blocking, asynchronous function calls.

    create_trip_list_view/
        TODO

    alt/ <- Alternative trip planning UI. Implemented by Nurdaulet (xturarn00)
        map_view/ <- FE for using a map widget.
        onboarding_screen/
        search_bar/ <- FE for using a search bar widget.
        
        trip/ <- Contains an equivalent of ViewModel of a trip
        trip_screen/

        trip_list/ <- Contains an equivalent of ViewModel of all trips
        trip_list_screen/

        alt_app.dart

    settings/ <- Settings screen to configure the theme and application mode (Nmode, Alternative). Implemneted by Nurdaulet (xturarn00)
    
    main.dart <- Program's entrypoint

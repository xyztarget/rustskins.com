<!DOCTYPE html>
<html lang="sk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>RustSkins</title>

    <!-- GAMING FONT -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Orbitron", sans-serif;
            background: #111315;
            color: white;
        }

        header {
            background: #1a1d20;
            padding: 20px 40px;
            border-bottom: 1px solid #292d31;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: auto;
        }

        .logo {
            font-size: 28px;
            font-weight: 800;
            letter-spacing: 1px;
        }

        .logo span {
            color: #e67e22;
        }

        /* =========================
           POČÍTADLO
        ========================= */

        #visitor-count {
            color: white;
            font-size: 16px;
            font-weight: 700;
        }

        /* =========================
           HLAVNÁ STRÁNKA
        ========================= */

        .container {
            max-width: 1200px;
            margin: auto;
            padding: 40px 20px;
        }

        .hero {
            text-align: center;
            margin-bottom: 40px;
        }

        .hero h1 {
            font-size: 42px;
            font-weight: 800;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .hero p {
            color: #999;
            margin-bottom: 25px;
            font-size: 13px;
            letter-spacing: 0.5px;
        }

        /* =========================
           SEARCH
        ========================= */

        .search {
            width: 100%;
            max-width: 600px;
            padding: 16px;
            border-radius: 8px;
            border: 1px solid #333;
            background: #1b1e21;
            color: white;
            font-family: "Orbitron", sans-serif;
            font-size: 14px;
            outline: none;
        }

        .search:focus {
            border-color: #e67e22;
        }

        .search::placeholder {
            color: #777;
        }

        /* =========================
           SKINY
        ========================= */

        .skins {
            display: grid;
            grid-template-columns: repeat(
                auto-fill,
                minmax(220px, 1fr)
            );
            gap: 20px;
        }

        .skin {
            background: #1a1d20;
            border: 1px solid #292d31;
            border-radius: 10px;
            overflow: hidden;
            transition:
                transform 0.2s,
                border-color 0.2s;
        }

        .skin:hover {
            transform: translateY(-3px);
            border-color: #e67e22;
        }

        .skin img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            background: #222;
        }

        .skin-info {
            padding: 15px;
        }

        .skin-name {
            font-weight: 700;
            margin-bottom: 8px;
            font-size: 13px;
        }

        .price {
            color: #e67e22;
            font-size: 17px;
            font-weight: 800;
        }

        /* =========================
           STATUS
        ========================= */

        #status {
            text-align: center;
            color: #888;
            margin-bottom: 20px;
            font-size: 12px;
        }

        /* =========================
           MOBILE
        ========================= */

        @media (max-width: 600px) {

            header {
                padding: 15px 20px;
            }

            .logo {
                font-size: 22px;
            }

            #visitor-count {
                font-size: 14px;
            }

            .container {
                padding: 30px 15px;
            }

            .hero h1 {
                font-size: 28px;
            }

            .hero p {
                font-size: 11px;
            }

        }

    </style>
</head>


<body>

<header>

    <div class="header-content">

        <div class="logo">
            Rust<span>Skins</span>
        </div>

        <!-- IBA ČÍSLO -->
        <div id="visitor-count">
            <span id="visitor-number">0</span>
        </div>

    </div>

</header>


<div class="container">

    <div class="hero">

        <h1>RUST SKINS DATABASE</h1>

        <p>
            Browse Rust skins, prices and categories.
        </p>

        <input
            id="search"
            class="search"
            type="text"
            placeholder="Search for a skin..."
        >

    </div>


    <div id="status">
        Loading skins...
    </div>


    <div id="skins" class="skins"></div>

</div>


<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>


<script>

const SUPABASE_URL =
    "https://nckagjgdvnswxldwjdsu.supabase.co";


/*
   NECHAJ TU SVOJ AKTUÁLNY
   SUPABASE PUBLISHABLE KEY
*/

const SUPABASE_KEY =
    "SEM_VLOZ_SVOJ_AKTUALNY_PUBLISHABLE_KEY";


const supabaseClient =
    supabase.createClient(
        SUPABASE_URL,
        SUPABASE_KEY
    );


let allSkins = [];


/* =========================
   NAČÍTANIE SKINOV
========================= */

async function loadSkins() {

    const { data, error } =
        await supabaseClient
            .from("skins")
            .select("*")
            .order("name");


    if (error) {

        document.getElementById("status").textContent =
            "Chyba pri načítaní skinov.";

        console.error(
            "Skins error:",
            error
        );

        return;
    }


    allSkins = data;

    displaySkins(data);
}


/* =========================
   ZOBRAZENIE SKINOV
========================= */

function displaySkins(skins) {

    const container =
        document.getElementById("skins");


    if (skins.length === 0) {

        container.innerHTML =
            "<p>Žiadne skiny zatiaľ nie sú v databáze.</p>";

        document.getElementById("status").textContent = "";

        return;
    }


    document.getElementById("status").textContent = "";


    container.innerHTML =
        skins.map(skin => `

            <div class="skin">

                <img
                    src="${skin.image_url}"
                    alt="${skin.name}"
                >

                <div class="skin-info">

                    <div class="skin-name">
                        ${skin.name}
                    </div>

                    <div class="price">
                        $${skin.price}
                    </div>

                </div>

            </div>

        `).join("");
}


/* =========================
   VYHĽADÁVANIE
========================= */

document
    .getElementById("search")
    .addEventListener(
        "input",
        function() {

            const search =
                this.value.toLowerCase();


            const filtered =
                allSkins.filter(
                    skin =>
                        skin.name
                            .toLowerCase()
                            .includes(search)
                );


            displaySkins(filtered);

        }
    );


/* =========================
   POČÍTADLO
========================= */

async function countVisitor() {

    let visitorId =
        localStorage.getItem(
            "rustskins_visitor_id"
        );


    if (!visitorId) {

        visitorId =
            crypto.randomUUID();


        localStorage.setItem(
            "rustskins_visitor_id",
            visitorId
        );


        const { error } =
            await supabaseClient
                .from("visitors")
                .insert({
                    visitor_id: visitorId
                });


        if (error) {

            console.error(
                "Visitor insert error:",
                error
            );

        }

    }


    const { count, error } =
        await supabaseClient
            .from("visitors")
            .select("*", {
                count: "exact",
                head: true
            });


    if (error) {

        console.error(
            "Visitor count error:",
            error
        );

        return;
    }


    document.getElementById(
        "visitor-number"
    ).textContent = count;

}


/* =========================
   SPUSTENIE
========================= */

loadSkins();

countVisitor();

</script>

</body>
</html>

<!DOCTYPE html>
<html lang="sk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RustSkins</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #111315;
            color: white;
        }

        header {
            background: #1a1d20;
            padding: 20px 40px;
            border-bottom: 1px solid #292d31;
        }

        .logo {
            font-size: 28px;
            font-weight: bold;
        }

        .logo span {
            color: #e67e22;
        }

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
            margin-bottom: 10px;
        }

        .hero p {
            color: #999;
            margin-bottom: 25px;
        }

        .search {
            width: 100%;
            max-width: 600px;
            padding: 16px;
            border-radius: 8px;
            border: 1px solid #333;
            background: #1b1e21;
            color: white;
            font-size: 16px;
        }

        .categories {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .category {
            background: #1b1e21;
            border: 1px solid #333;
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
        }

        .category:hover {
            border-color: #e67e22;
        }

        .skins {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }

        .skin {
            background: #1a1d20;
            border: 1px solid #292d31;
            border-radius: 10px;
            overflow: hidden;
            transition: 0.2s;
        }

        .skin:hover {
            transform: translateY(-4px);
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
            font-weight: bold;
            margin-bottom: 8px;
        }

        .price {
            color: #e67e22;
            font-size: 18px;
            font-weight: bold;
        }
    </style>
</head>

<body>

<header>
    <div class="logo">Rust<span>Skins</span></div>
</header>

<div class="container">

    <div class="hero">
        <h1>Rust Skins Database</h1>
        <p>Browse Rust skins, prices and categories.</p>

        <input
            class="search"
            type="text"
            placeholder="Search for a skin..."
        >
    </div>

    <div class="categories">
        <div class="category">All</div>
        <div class="category">Weapons</div>
        <div class="category">Clothing</div>
        <div class="category">Tools</div>
        <div class="category">Buildings</div>
    </div>

    <div class="skins">

        <div class="skin">
            <img src="https://placehold.co/600x400/222/fff?text=Rust+Skin">
            <div class="skin-info">
                <div class="skin-name">Example AK-47 Skin</div>
                <div class="price">$4.99</div>
            </div>
        </div>

        <div class="skin">
            <img src="https://placehold.co/600x400/222/fff?text=Rust+Skin">
            <div class="skin-info">
                <div class="skin-name">Example Hoodie</div>
                <div class="price">$2.49</div>
            </div>
        </div>

        <div class="skin">
            <img src="https://placehold.co/600x400/222/fff?text=Rust+Skin">
            <div class="skin-info">
                <div class="skin-name">Example Pickaxe</div>
                <div class="price">$7.99</div>
            </div>
        </div>

    </div>

</div>

</body>
</html>

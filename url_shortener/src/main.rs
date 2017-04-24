#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
extern crate serde_json;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate serde_derive;

#[cfg(test)]
mod tests;
use rocket_contrib::{JSON, Value};

#[derive(Serialize, Deserialize, Debug)]
struct LongUrl {
    url: String,
}

#[get("/<id>")]
fn lookup(id: &str) -> String {
    format!("You requested {}. Wonderful!", id)
}

#[get("/<url>")]
fn shorten(url: &str) -> String {
    format!("You shortened {}. Magnificient!", url)
}

#[post("/", format="application/json", data="<body>")]
fn create(body: JSON<LongUrl>) -> JSON<Value> {
    let root = "https://kupibilet.ru/".to_string();
    let full_url_to_response = root + "gh45";
    println!("{:?}", body.url);
    JSON(json!({
                   "url": full_url_to_response
               }))
}

fn main() {
    rocket::ignite()
        .mount("/", routes![lookup])
        .mount("/shorten", routes![shorten])
        .launch();
}
//
//
//
// self::app;
// std::fileReader;
//
// fn main() {
//   let config = read_config;
//   app.run(config);
// }
//
//
//
//
//
//

extern crate url_shortener;

use super::rocket;
use rocket::testing::MockRequest;
use rocket::http::{Method, Status};

#[test]
fn test() {
    let rocket = rocket::ignite().mount("/", routes![super::shorten, super::lookup]);
    let mut request = MockRequest::new(Method::Get, "/my_super_url");
    let response = request.dispatch_with(&rocket);
    assert_eq!(response.status(), Status::Ok);
}

#[test]
fn test_redirect_to_full_url() {
    let rocket = rocket::ignite().mount("/", routes![super::shorten, super::lookup]);
    let mut request = MockRequest::new(Method::Get, "/ghtyu");
    let mut response = request.dispatch_with(&rocket);
    let body_string = response.body().and_then(|b| b.into_string());
    assert_eq!(response.status(), Status::Ok);
    assert_eq!(body_string,
               Some("You shortened ghtyu. Magnificient!".to_string()));
}

#[test]
fn test_json_response() {
    let rocket = rocket::ignite().mount("/", routes![super::shorten, super::lookup, super::create]);
    let mut request = MockRequest::new(Method::Post, "/")
        .header(rocket::http::ContentType::JSON)
        .body(r#"{ "url": "https://kupibilet.ru/i_hate_this_long_url"}"#);
    let mut response = request.dispatch_with(&rocket);
    let body_string = response.body().unwrap().into_string().unwrap();
    let expected = r#"{"url":"https://kupibilet.ru/gh45"}"#;
    assert_eq!(response.status(), Status::Ok);
    assert_eq!(body_string, expected);
}

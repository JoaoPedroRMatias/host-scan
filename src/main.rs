use std::io::{self, Write};
use std::net::Ipv4Addr;
use std::process::Command;

fn validate_ip(ip: &str) -> Option<Ipv4Addr> {
    ip.parse::<Ipv4Addr>().ok()
}

fn transform_last_number_to_zero(ip: &Ipv4Addr) -> Ipv4Addr {
    let octets = ip.octets();
    Ipv4Addr::new(octets[0], octets[1], octets[2], 0)
}

fn transform_last_number_increment(ip: &Ipv4Addr) -> Option<Ipv4Addr> {
    let mut octets = ip.octets();
    if octets[3] < 255 {
        octets[3] += 1;
        Some(Ipv4Addr::from(octets))
    } else {
        None
    }
}

fn progress_bar(percent: usize) {
    print!("\r");
    for i in 0..50 {
        if i < percent {
            print!("\x1b[97m▇\x1b[0m");
        } else {
            print!("\x1b[37m▇\x1b[0m");
        }
    }
    print!(" {}%", percent * 2);
    io::stdout().flush().unwrap();
}

fn is_host_alive(ip: &Ipv4Addr) -> bool {
    Command::new("ping")
        .args(["-c", "1", "-W", "1", &ip.to_string()])
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

fn main() {
    println!(
        "
░█░█░█▀█░█▀▀░▀█▀░█▀▀░█▀▀░█▀█░█▀█
░█▀█░█░█░▀▀█░░█░░▀▀█░█░░░█▀█░█░█
░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀░▀

Tool to scan hosts on the network.
Enter the IP in the following format: xxx.xxx.xxx.xxx\n"
    );

    print!("Enter the IP address: ");
    io::stdout().flush().unwrap();

    let mut input_ip = String::new();
    io::stdin().read_line(&mut input_ip).unwrap();
    let input_ip = input_ip.trim();

    let base_ip = match validate_ip(input_ip) {
        Some(ip) => transform_last_number_to_zero(&ip),
        None => {
            println!("Erro: Formato de endereço IP inválido!");
            return;
        }
    };

    println!("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓");
    println!("┃\t\t   ACTIVE HOSTS\t\t\t ┃");
    println!("┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫");

    let mut current_ip = transform_last_number_increment(&base_ip).unwrap();
    let mut completed_ips = 0;
    let total_ips = 254;

    while current_ip.octets()[3] < 254 {
        if is_host_alive(&current_ip) {
            println!("┃ ➤ {} \t\x1b[32m✔\x1b[0m\t\t\t ┃", current_ip);
        }

        completed_ips += 1;
        let percent = (completed_ips * 50) / total_ips;
        progress_bar(percent);

        match transform_last_number_increment(&current_ip) {
            Some(next_ip) => current_ip = next_ip,
            None => break,
        }
    }

    println!("\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛");
}

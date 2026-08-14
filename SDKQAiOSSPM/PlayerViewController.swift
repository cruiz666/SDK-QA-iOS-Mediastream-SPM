//
//  PlayerViewController.swift
//  SDKQAiOSSPM
//
//  Pantalla de un caso: el player arriba y el registro de eventos abajo.
//

import UIKit
import MediastreamPlatformSDKiOS

final class PlayerViewController: UIViewController {

    private let testCase: TestCase
    private var sdk: MediastreamPlatformSDK?

    private let playerContainer = UIView()
    private let logTable = UITableView(frame: .zero, style: .plain)
    private let versionLabel = UILabel()

    init(testCase: TestCase) {
        self.testCase = testCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no soportado") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = testCase.title
        view.backgroundColor = .qaBackground

        buildLayout()
        EventLog.shared.clear()
        EventLog.shared.onChange = { [weak self] in self?.reloadLog() }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(shareLog))

        loadPlayer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { teardown() }
    }

    // MARK: - Layout

    private func buildLayout() {
        playerContainer.backgroundColor = .black
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerContainer)

        // La versión sale de getVersion(), que la lee del bundle del framework. Sirve para
        // que un reporte de QA diga contra qué build se probó, sin depender de memoria.
        versionLabel.text = "SDK \(MediastreamPlatformSDK().getVersion())  ·  \(testCase.detail)"
        versionLabel.font = .qaMono(11)
        versionLabel.textColor = .qaSecondaryLabel
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)

        logTable.dataSource = self
        logTable.rowHeight = UITableView.automaticDimension
        logTable.estimatedRowHeight = 28
        logTable.register(UITableViewCell.self, forCellReuseIdentifier: "event")
        logTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logTable)

        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerContainer.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9.0 / 16.0),

            versionLabel.topAnchor.constraint(equalTo: playerContainer.bottomAnchor, constant: 8),
            versionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            versionLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            logTable.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 8),
            logTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Player

    private func loadPlayer() {
        let config = MediastreamPlayerConfig()
        testCase.configure(config)

        let player = MediastreamPlatformSDK()
        sdk = player

        addChild(player)
        player.view.frame = playerContainer.bounds
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerContainer.addSubview(player.view)
        player.didMove(toParent: self)

        // Antes del setup, para no perder los eventos de la carga inicial.
        SDKEventListeners.attachAll(to: player.events)

        player.setup(config)
        player.play()
    }

    private func teardown() {
        guard let player = sdk else { return }
        player.releasePlayer()
        player.willMove(toParent: nil)
        player.view.removeFromSuperview()
        player.removeFromParent()
        sdk = nil
        EventLog.shared.onChange = nil
    }

    // MARK: - Log

    private func reloadLog() {
        logTable.reloadData()
        let last = EventLog.shared.entries.count - 1
        guard last >= 0 else { return }
        logTable.scrollToRow(at: IndexPath(row: last, section: 0), at: .bottom, animated: false)
    }

    @objc private func shareLog() {
        let text = EventLog.shared.plainText
        guard !text.isEmpty else { return }
        let share = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        share.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(share, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension PlayerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        EventLog.shared.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath)
        cell.textLabel?.text = EventLog.shared.line(at: indexPath.row)
        cell.textLabel?.font = .qaMono(11)
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
}

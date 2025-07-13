# Contributing to kansai_train_info

[日本語](CONTRIBUTING.md)

Thank you for considering contributing to this project!

## Setting up Development Environment

1. Fork the repository
2. Clone locally
   ```bash
   git clone https://github.com/your-username/kansai_train_info.git
   cd kansai_train_info
   ```

3. Install dependencies
   ```bash
   bundle install
   ```

4. Run tests
   ```bash
   bundle exec rspec
   ```

## Development Guidelines

### Coding Standards

- Follow Rubocop rules
  ```bash
  bundle exec rubocop
  ```

- Run type checking
  ```bash
  bundle exec steep check
  ```

### Testing

- Always add tests for new features
- Maintain test coverage above 90%
- Run tests with:
  ```bash
  bundle exec rspec
  ```

### Commit Messages

Follow this format for commit messages:

```
<type>: <subject>

<body>

<footer>
```

Type:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (whitespace, formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or modifying tests
- `chore`: Changes to build process or tools

### Pull Requests

1. Create a feature branch
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Commit your changes
   ```bash
   git commit -m "feat: add new feature"
   ```

3. Push the branch
   ```bash
   git push origin feature/your-feature-name
   ```

4. Create a Pull Request on GitHub

### Pull Request Checklist

- [ ] All tests pass
- [ ] No Rubocop warnings
- [ ] Steep type checking passes
- [ ] Test coverage is above 90%
- [ ] Appropriate documentation added
- [ ] Changes documented in CHANGELOG

## Adding New Lines

To add a new train line:

1. Get required information from Yahoo! Transit Info
   - Area index
   - Row index
   - Detail ID

2. Add to LINES hash in `lib/kansai_train_info/client.rb`:
   ```ruby
   LINES = {
     # ...
     新路線名: [area_index, row_index, detail_id]
   }
   ```

3. Add tests
4. Update README

## Reporting Issues

If you find a bug or have a feature request, please report it on [Issues](https://github.com/o8n/kansai_train_info/issues).

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.
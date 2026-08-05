(() => {
  'use strict';

  document.documentElement.classList.add('js');

  const storageKey = 'jiahui-site-language';
  const translated = document.querySelectorAll('[data-en][data-zh]');
  const switcher = document.querySelector('[data-language-toggle]');
  const menuButton = document.querySelector('[data-menu-toggle]');
  const navigation = document.querySelector('[data-navigation]');

  function saveLanguage(language) {
    try {
      window.localStorage.setItem(storageKey, language);
    } catch (_) {
      // Language switching remains usable when storage is unavailable.
    }
  }

  function loadLanguage() {
    try {
      return window.localStorage.getItem(storageKey) || 'en';
    } catch (_) {
      return 'en';
    }
  }

  function setLanguage(language) {
    const next = language === 'zh' ? 'zh' : 'en';
    const titleKey = next === 'zh' ? 'titleZh' : 'titleEn';

    document.documentElement.lang = next === 'zh' ? 'zh-CN' : 'en';
    translated.forEach((node) => {
      node.textContent = node.dataset[next];
    });

    if (document.body && document.body.dataset[titleKey]) {
      document.title = document.body.dataset[titleKey];
    }

    if (switcher) {
      switcher.textContent = next === 'zh' ? 'EN' : '中文';
      switcher.setAttribute('aria-label', next === 'zh' ? 'Switch to English' : '切换到中文');
    }

    saveLanguage(next);
  }

  setLanguage(loadLanguage());

  if (switcher) {
    switcher.addEventListener('click', () => {
      setLanguage(document.documentElement.lang.startsWith('zh') ? 'en' : 'zh');
    });
  }

  if (menuButton && navigation) {
    const closeNavigation = () => {
      navigation.classList.remove('is-open');
      menuButton.setAttribute('aria-expanded', 'false');
    };

    menuButton.addEventListener('click', () => {
      const open = navigation.classList.toggle('is-open');
      menuButton.setAttribute('aria-expanded', String(open));
    });

    navigation.addEventListener('click', (event) => {
      if (event.target.closest('a')) {
        closeNavigation();
      }
    });

    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && navigation.classList.contains('is-open')) {
        closeNavigation();
        menuButton.focus();
      }
    });

    document.addEventListener('click', (event) => {
      if (
        navigation.classList.contains('is-open') &&
        !navigation.contains(event.target) &&
        !menuButton.contains(event.target)
      ) {
        closeNavigation();
      }
    });
  }

  if (navigation) {
    const page = window.location.pathname.split('/').pop() || 'index.html';
    navigation.querySelectorAll('a[href]').forEach((link) => {
      const target = link.getAttribute('href').split(/[?#]/)[0].replace(/^\.\//, '');
      if (target === page || (page === '' && target === 'index.html')) {
        link.setAttribute('aria-current', 'page');
      }
    });
  }

  const revealElements = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });

    revealElements.forEach((element) => observer.observe(element));
  } else {
    revealElements.forEach((element) => element.classList.add('is-visible'));
  }
})();

/**
 * God Mode — Main JavaScript
 * Search, filter, and tag functionality for the topic hub
 */

// ─── Topic Data Registry ───
const TOPICS = [
  {
    id: 'music-production-bitwig',
    title: 'Bitwig Studio for Acoustic & Folk Music',
    description: 'Making polished acoustic, folk, folk rock, indie rock, and alt-country music in Bitwig Studio — a DAW built for ambient & EDM. Tips, plugins, FX, MIDI, AI tools.',
    icon: '🎸',
    status: 'Active',
    tags: ['music', 'bitwig', 'production', 'folk', 'indie-rock', 'plugins', 'midi', 'ai'],
    artifacts: 9,
    sources: 0,
    lastUpdated: '2026-03-03',
    url: 'topics/music-production-bitwig/',
    color: 'linear-gradient(135deg, #6c5ce7, #fd79a8)'
  }
  ,
  {
    id: 'james-talarico-senate',
    title: 'James Talarico: Can He Win the Texas Senate?',
    description: 'TX State Rep. James Talarico (D) is running for U.S. Senate. Democratic primary is March 3, 2026 vs Jasmine Crockett. Polls, analysis, YouTube coverage, and AI-generated artifacts.',
    icon: '🗳️',
    status: 'Active',
    tags: ['politics', 'texas', 'senate-2026', 'democratic-primary', 'election'],
    artifacts: 9,
    sources: 10,
    lastUpdated: '2026-03-03',
    url: 'topics/james-talarico-senate/',
    color: 'linear-gradient(135deg, #6c5ce7, #00cec9)'
  }
  // Add more topics here following this format
];

// All unique tags across topics
function getAllTags() {
  const tagSet = new Set();
  TOPICS.forEach(t => t.tags.forEach(tag => tagSet.add(tag)));
  return Array.from(tagSet).sort();
}

// ─── State ───
let activeTag = null;
let searchQuery = '';

// ─── DOM Ready ───
document.addEventListener('DOMContentLoaded', () => {
  renderStats();
  renderTags();
  renderTopics();
  setupSearch();
  setupScrollEffects();
});

// ─── Render Stats ───
function renderStats() {
  const el = document.getElementById('stats-bar');
  if (!el) return;

  const totalArtifacts = TOPICS.reduce((sum, t) => sum + t.artifacts, 0);
  const totalSources = TOPICS.reduce((sum, t) => sum + t.sources, 0);

  el.innerHTML = `
    <div class="stat-card glass-card">
      <div class="stat-number">${TOPICS.length}</div>
      <div class="stat-label">Research Topics</div>
    </div>
    <div class="stat-card glass-card">
      <div class="stat-number">${totalArtifacts}</div>
      <div class="stat-label">NLM Artifacts</div>
    </div>
    <div class="stat-card glass-card">
      <div class="stat-number">${totalSources}</div>
      <div class="stat-label">Sources</div>
    </div>
    <div class="stat-card glass-card">
      <div class="stat-number">${getAllTags().length}</div>
      <div class="stat-label">Tags</div>
    </div>
  `;
}

// ─── Render Tags ───
function renderTags() {
  const el = document.getElementById('tags-bar');
  if (!el) return;

  const tags = getAllTags();
  el.innerHTML = `
    <span class="tag ${!activeTag ? 'active' : ''}" data-tag="">All</span>
    ${tags.map(tag => `
      <span class="tag ${activeTag === tag ? 'active' : ''}" data-tag="${tag}">${tag}</span>
    `).join('')}
  `;

  el.querySelectorAll('.tag').forEach(tagEl => {
    tagEl.addEventListener('click', () => {
      const tag = tagEl.dataset.tag;
      activeTag = tag || null;
      renderTags();
      renderTopics();
    });
  });
}

// ─── Render Topic Cards ───
function renderTopics() {
  const el = document.getElementById('topics-grid');
  if (!el) return;

  let filtered = TOPICS;

  // Filter by search
  if (searchQuery) {
    const q = searchQuery.toLowerCase();
    filtered = filtered.filter(t =>
      t.title.toLowerCase().includes(q) ||
      t.description.toLowerCase().includes(q) ||
      t.tags.some(tag => tag.includes(q))
    );
  }

  // Filter by tag
  if (activeTag) {
    filtered = filtered.filter(t => t.tags.includes(activeTag));
  }

  if (filtered.length === 0) {
    el.innerHTML = `
      <div style="grid-column: 1/-1; text-align: center; padding: 60px 20px;">
        <div style="font-size: 3rem; margin-bottom: 16px;">🔍</div>
        <h3 style="color: var(--text-secondary); margin-bottom: 8px;">No topics found</h3>
        <p style="color: var(--text-muted);">Try a different search or filter</p>
      </div>
    `;
    return;
  }

  el.innerHTML = filtered.map((topic, i) => `
    <a href="${topic.url}" class="topic-card glass-card animate-in" style="animation-delay: ${i * 0.1}s; text-decoration: none;">
      <div class="topic-card-header">
        <div class="topic-card-icon">${topic.icon}</div>
        <div class="topic-card-status">
          <span class="status-dot"></span>
          ${topic.status}
        </div>
      </div>
      <h3>${topic.title}</h3>
      <p>${topic.description}</p>
      <div class="topic-card-tags">
        ${topic.tags.slice(0, 5).map(tag => `<span class="topic-card-tag">${tag}</span>`).join('')}
        ${topic.tags.length > 5 ? `<span class="topic-card-tag">+${topic.tags.length - 5}</span>` : ''}
      </div>
      <div class="topic-card-meta">
        <div class="meta-item">📦 ${topic.artifacts} artifacts</div>
        <div class="meta-item">📚 ${topic.sources} sources</div>
        <div class="meta-item">🕐 ${topic.lastUpdated}</div>
      </div>
    </a>
  `).join('');
}

// ─── Search Setup ───
function setupSearch() {
  const input = document.getElementById('search-input');
  if (!input) return;

  let debounceTimer;
  input.addEventListener('input', (e) => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      searchQuery = e.target.value.trim();
      renderTopics();
    }, 200);
  });

  // Keyboard shortcut: "/" to focus search
  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && document.activeElement !== input) {
      e.preventDefault();
      input.focus();
    }
    if (e.key === 'Escape') {
      input.blur();
      input.value = '';
      searchQuery = '';
      renderTopics();
    }
  });
}

// ─── Scroll Effects ───
function setupScrollEffects() {
  const nav = document.querySelector('.nav');
  if (!nav) return;

  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      nav.style.background = 'rgba(10, 10, 15, 0.95)';
    } else {
      nav.style.background = 'rgba(10, 10, 15, 0.8)';
    }
  });

  // Intersection observer for animations
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll('.animate-on-scroll').forEach(el => observer.observe(el));
}

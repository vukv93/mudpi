return {
  lazyconfig = {
    {
      'nvim-orgmode/orgmode',
      event = 'VeryLazy',
      ft = { 'org' },
      config = function()
        local ndir = os.getenv('NOUUA')
        require('orgmode').setup({
          org_agenda_files = ndir .. '/org/**/*',
          org_default_notes_file = ndir .. '/org/quick.org',
          -- @todo[250107_004504] Emacs setup.
          emacs_config = {
            executable_path = 'emacs',
            config_path = '/dev/null',
          },
          mappings = {
            prefix = ',c',
          },
        })
      end,
    },
  },
}

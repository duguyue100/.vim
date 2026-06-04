return {
	'xeluxee/competitest.nvim',
    lazy = false,
	dependencies = 'MunifTanjim/nui.nvim',
	config = function()
        require('competitest').setup{
            compile_command = {
                cpp = {
                    exec = 'g++-15',
                    args = {'$(FNAME)', '-o', '$(FNOEXT)'},
                },
            },
            run_command = {
                cpp = { exec = './$(FNOEXT)' },
            },
        }
    end,
}

/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_hexa.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/04/02 08:14:59 by rhanitra          #+#    #+#             */
/*   Updated: 2024/07/13 14:17:39 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "ft_printf.h"

char	*reverse_print(const char *str)
{
	int		i;
	int		j;
	char	*new_str;

	j = 0;
	i = ft_strlen(str) - 1;
	new_str = (char *)malloc(sizeof(char) * ft_strlen(str) + 1);
	while (i >= 0)
	{
		new_str[j] = str[i];
		i--;
		j++;
	}
	new_str[j] = '\0';
	return (new_str);
}

char	*ft_putnbr_base_ul(char const *base, unsigned long input, int base_type)
{
	int		i;
	int		value;
	char	*str;
	char	*ret;

	i = 0;
	value = 0;
	str = (char *)malloc(sizeof(char) * (ft_nbrlen(input) + 1));
	if (!str)
		ft_strdup("");
	if (input == 0)
	{
		free(str);
		return ("0");
	}
	while (input > 0)
	{
		value = input % base_type;
		str[i++] = base[value];
		input /= base_type;
	}
	str[i] = '\0';
	ret = reverse_print(str);
	free(str);
	return (ret);
}

int	ft_print_hexa(unsigned long input, const char *base, int base_type)
{
	int		i;
	char	*str;

	i = 0;
	str = ft_putnbr_base_ul(base, input, base_type);
	while (str[i] != '\0')
	{
		write(1, &str[i], 1);
		i++;
	}
	if (input != 0)
		free(str);
	return (i);
}
